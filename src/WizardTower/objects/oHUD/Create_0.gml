/// @description 
function hud_get_action(){
	var rtn = my_action;
	my_action = {}
	return rtn;
}
function set_my_action_ability(_value){
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
xx = 0;
yy = 0;
minimap_height = display_get_gui_height() div 3;
minimap_width = minimap_height;
minimap_x = 0;
minimap_y = minimap_height*2;
minimap_tile_ox = 0;
minimap_tile_oy = 0;
minimap_tile_size = 4;

// player data stuff
player_data_string = "";
player_data_width = round(display_get_gui_height()*0.75);
player_data_height = display_get_gui_height() div 4;
player_data_x = minimap_width+1
player_data_y = player_data_height*3;

// action stuff
abilities_width = display_get_gui_height() div 2;
abilities_height = display_get_gui_height() div 2;
abilities_x = display_get_gui_width() - abilities_width-1; 
abilities_y = display_get_gui_height() - abilities_height-1;
abilities_buttons = array_create(9,0);
for(var i=0;i<9;i++)
{
	var _struct = {
		text : "Action\n"+string(i+1),
		gui : true,
		action_index : i,
		leftScript : set_my_action_ability,
		leftArgs : [i],
		rightScript : set_my_action_ability,
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
show_selected_entities = false;
show_wave_data = false;

function Init(){
	switch(room)
	{
		case rDebug:
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
			var _sep = 36;
			var _cx = ((abilities_bbox[2]+abilities_bbox[0]) div 2) - 1.5*_sep;
			var _cy = ((abilities_bbox[3]+abilities_bbox[1]) div 2) - 1.5*_sep;
			for(var i=0;i<9;i++){
				with(abilities_buttons[i])
				{
					x = _cx + i%3*_sep;
					y = _cy + (i div 3)*_sep;
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
			break;
		case rShaderTest:
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

			break;
		default:
			enable_player_data = false;
			enable_minimap = false;
			ox = 0;
			oy = 0;
			// abilities stufff
			enable_abilities = false;
			for(var i=0;i<9;i++){ abilities_buttons[i].visible = false }
			break;
	}
}

function draw_minimap(){
	draw_set_alpha(0.3);
	draw_set_color(c_black);
	draw_rectangle(minimap_bbox[0],minimap_bbox[1],minimap_bbox[2],minimap_bbox[3],false);
	
	var _node=undefined;

	var color_background = c_black;
	var color_view = c_black;
	var color_null = c_white;
	var color_neutral = c_teal;
	var color_friendly = c_green;
	var color_enemy = c_red;

	draw_set_alpha(1);
	draw_set_color(color_background);
	draw_rectangle(ox-1,oy-1,ox+global.game_grid_width*minimap_tile_size,oy+global.game_grid_height*minimap_tile_size,false);
	for(var i=0;i<global.game_grid_width;i++){
	for(var j=0;j<global.game_grid_height;j++){
		_node = global.game_grid[# i, j];
		var _xinc = ox + i*minimap_tile_size;
		var _yinc = oy + j*minimap_tile_size;
		var _inst = noone;
		if(ds_list_size(_node.occupied_list) == 0)
		{
			draw_set_color(color_null);
		} else {
			_inst = _node.occupied_list[| 0];
			
			if(!is_undefined(_inst)) && (instance_exists(_inst)) && (_inst.faction == PLAYER_FACTION)
			{
				draw_set_color(color_friendly);
			} else {
				draw_set_color(color_enemy);
			}
		}
		draw_rectangle(_xinc,_yinc,_xinc+minimap_tile_size-1,_yinc+minimap_tile_size-1,false)
	}}

	draw_set_color(color_view);
	draw_rectangle(minimap_view_bbox[0], minimap_view_bbox[1], minimap_view_bbox[2], minimap_view_bbox[3], true);


}
function draw_abilities(){
	draw_set_alpha(0.3);
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
	draw_text(player_data_x+2, player_data_y+2, player_data_string);
	
	// display mouse data
	draw_set_valign(fa_top);
	draw_set_halign(fa_right);
	draw_text(player_data_bbox[2], player_data_bbox[1], "camera location = [" + string(global.iCamera.x) + ", " + string(global.iCamera.y) + "] "+string(zoom)+"\n" 
					+ "mouse location = [" + string(mouse_x) + ", " + string(mouse_y) + "] [" 
					+ string((mouse_x-global.game_grid_xorigin) div GRID_SIZE) + ", " + string((mouse_y-global.game_grid_yorigin) div GRID_SIZE) + "]\n mouse focus = " 
					+ string(global.mouse_focus));
}
function draw_wave_data(){
	// display wave count & enemies remaining
	var _actor = global.iEngine.enemy_actor;
	draw_set_valign(fa_bottom);
	draw_set_halign(fa_right);
	draw_text(player_data_bbox[2], player_data_bbox[3]-4, 
	  "WAVE = [" + string(_actor.ai.wave_index) + " / " + string(array_length(_actor.ai.wave_keys)) + "]\n" 
	+ "enemies remaining = [" + string(ds_list_size(_actor.units) + ds_list_size(_actor.structures))+"]");
}

