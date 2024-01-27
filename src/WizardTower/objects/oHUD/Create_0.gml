/// @description 

function hud_get_action(){
	// get the action that has been stored in variable 'my_action'
	var rtn = my_action;
	// set 'my_action' to an empty struct
	my_action = {}
	// return the action that was retrieved previously
	return rtn;
}
function activate_my_action_ability(_value){
	with(global.iHUD)
	{
		my_action = {use_ability : new global.iEngine.Command("use_ability",_value,0,0)};
	}
}

my_action = {};

// mouse position on gui
mx = device_mouse_x_to_gui(0);
my = device_mouse_y_to_gui(0);

// minimap stuff
func = hud_minimap_functions;
xx = 0;
yy = 0;
minimap_height = 88;
minimap_width = 122;
minimap_x = 518;
minimap_y = 0;
minimap_tile_ox = 0;
minimap_tile_oy = 0;
minimap_tile_size = 4;

minimap_hexarr_pos = [];
minimap_h_spacing = 0;
minimap_v_spacing = 0;

// level progress stuff
level_progress_id = noone;
level_progress_x = 518;
level_progress_y = 0;

// inspector stuff
selection_inspector_id = noone;
selection_inspector_x = 224;
selection_inspector_y = 287;

// player data stuff
player_data_string = "";
mouse_position_data_string = "";
player_data_width = 94;
player_data_height = 73;
player_data_x = 130;
player_data_y = 287;

// action stuff
abilities_width = 129;
abilities_height = 128;
abilities_x = 0; 
abilities_y = display_get_gui_height()-abilities_height;
abilities_buttons = array_create(9,0);
for(var i=0;i<9;i++)
{
	var _struct = {
		text : "[" + string(i+1) + "]",
		gui : true,
		action_index : i,
		leftScript : activate_my_action_ability,
		leftArgs : [i],
		rightScript : activate_my_action_ability,
		rightArgs : [i],
		creator : id
	}
	abilities_buttons[i] = instance_create_depth(0,0,depth-1,btnPlayerAction,_struct);
}

enable_minimap = false;
enable_abilities = false;
enable_player_data = false;
abilities_bbox = array_create(4,0);
minimap_bbox = array_create(4,0);
minimap_view_bbox = array_create(4,0);
player_data_bbox = array_create(4,0);

// misc stuff
show_data_overlay = false;
show_selected_entities = false;
show_wave_data = false;

function Init(){
	if(room == rDebug) || (room == rHexTest)
	{
		// player data stuff
		enable_player_data = true;
		player_data_bbox[0] = player_data_x;
		player_data_bbox[1] = player_data_y;
		player_data_bbox[2] = player_data_x + player_data_width;
		player_data_bbox[3] = player_data_y + player_data_height;
		// abilities stufff
		enable_abilities = true;
		abilities_bbox[0] = abilities_x;
		abilities_bbox[1] = abilities_y;
		abilities_bbox[2] = abilities_x + abilities_width;
		abilities_bbox[3] = abilities_y + abilities_height;
		var _sep = 39;
		var _cx = ((abilities_bbox[2]+abilities_bbox[0]) div 2);
		var _cy = ((abilities_bbox[3]+abilities_bbox[1]) div 2);
		for(var i=0;i<9;i++){
			with(abilities_buttons[i])
			{
				x = _cx + ((i%3) -1)*_sep;
				y = _cy + ((i div 3) - 1)*_sep;
				visible = true;
				enabled = true;
			}
		}
		// minimap stuff
		enable_minimap = true;
		ox = minimap_x + (minimap_width div 2) - ((global.game_grid_width*minimap_tile_size) div 2);
		oy = minimap_y + (minimap_height div 2) - ((global.game_grid_height*minimap_tile_size) div 2);
		minimap_bbox[0] = minimap_x;
		minimap_bbox[1] = minimap_y;
		minimap_bbox[2] = minimap_x + minimap_width;
		minimap_bbox[3] = minimap_y + minimap_height;
		with(o_hex_grid)
		{
			other.minimap_h_spacing = h_spacing*0.03;
			other.minimap_v_spacing = v_spacing*0.03;
			array_copy(other.minimap_hexarr_pos,0,hexarr_positions,0,array_length(hexarr_positions));
		}
		// create the inspector and the level progress indicator
		with(oSelectionInspector) instance_destroy();
		var _struct = {creator : id};
		selection_inspector_id = instance_create_depth(selection_inspector_x, selection_inspector_y,depth-1,oSelectionInspector, _struct);
		with(oLevelProgressInspector) instance_destroy();
		_struct = {creator : id, middle_length : 0, middle_length_goal : 200}
		level_progress_id = instance_create_depth(level_progress_x, level_progress_y,depth-1,oLevelProgressInspector, _struct);
		
	} else if(room == rShaderTest){
		// player data stuff
		enable_player_data = false;
		// abilities stufff
		enable_abilities = false;
		for(var i=0; i<9;i++)
		{
			with(abilities_buttons[i])
			{
				enabled = false;
				visible = false;
			}
		}
		// minimap stuff
		enable_minimap = false;
	} else {
		enable_player_data = false;
		enable_minimap = false;
		ox = 0;
		oy = 0;
		// abilities stufff
		enable_abilities = false;
		for(var i=0;i<9;i++){ abilities_buttons[i].visible = false }
	}
}

function draw_minimap(){
	draw_set_alpha(0.3*image_alpha);
	draw_set_color(c_black);
	// show the area allocated to the minimap
	draw_rectangle(minimap_bbox[0],minimap_bbox[1],minimap_bbox[2],minimap_bbox[3],false);
	
	// define colors for each hex node state
	var color_background = c_black;
	var color_view = c_black;
	var color_null = c_white;
	var color_neutral = c_teal;
	var color_friendly = c_green;
	var color_enemy = c_red;
/*
	// draw background for the minimap
	draw_set_alpha(1);
	draw_set_color(color_background);
	draw_rectangle(ox-1,oy-1,ox+global.game_grid_width*minimap_tile_size,oy+global.game_grid_height*minimap_tile_size,false);

	// show all the map nodes
	for(var i=0;i<global.game_grid_width;i++){
	for(var j=0;j<global.game_grid_height;j++){
		var _xinc = ox + i*minimap_tile_size;
		var _yinc = oy + j*minimap_tile_size;
		var _inst = noone;

		draw_set_color(color_null);

		draw_rectangle(_xinc,_yinc,_xinc+minimap_tile_size-1,_yinc+minimap_tile_size-1,false)
	}}
*/
	// indicate where the view is on the minimap
	draw_rectangle(minimap_view_bbox[0], minimap_view_bbox[1], minimap_view_bbox[2], minimap_view_bbox[3], true);


}
function draw_abilities(){
	// the abilities are drawn by the button objects
	
	draw_set_alpha(0.3*image_alpha);
	draw_set_color(c_aqua);
	draw_rectangle(abilities_bbox[0],abilities_bbox[1],abilities_bbox[2],abilities_bbox[3],false);
}
function draw_player_data(){
	draw_set_alpha(0.3);
	draw_set_color(c_red);
	draw_rectangle(player_data_bbox[0],player_data_bbox[1],player_data_bbox[2],player_data_bbox[3],false);
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_text(player_data_x+4, player_data_y+4, player_data_string);
	/*
	// display mouse data
	draw_text(player_data_bbox[2]+6, player_data_bbox[1]+2, "camera location = [" + string(global.iCamera.x) + ", " + string(global.iCamera.y) + "] "+string(zoom)+"\n" 
					+ mouse_position_data_string + 
					"mouse focus = " + string(global.mouse_focus));
	*/
}
function Hide(){
	enable_minimap = false;
	enable_abilities = false;
	enable_player_data = false;
	show_data_overlay = false;
	show_selected_entities = false;
	show_wave_data = false;
	for(var i=0;i<array_length(abilities_buttons); i++)
	{
		with(abilities_buttons[i])
		{
			enabled = false;
			image_alpha = 0;
		}
	}
}
function Show(){
	enable_minimap = false;
	enable_abilities = false;
	enable_player_data = false;
	show_data_overlay = false;
	show_selected_entities = false;
	show_wave_data = false;
	for(var i=0;i<array_length(abilities_buttons); i++)
	{
		with(abilities_buttons[i])
		{
			enabled = true;
			image_alpha = 1;
		}
	}
}
