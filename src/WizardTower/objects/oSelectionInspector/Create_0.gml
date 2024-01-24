/// @description 

function inspect(_inst){
	target = _inst;
	if(_inst == noone){
		inspect_script = inspect_noone_draw;
	} else {
		if(_inst.entity_type == UNIT){
			inspect_script = _inst.faction == PLAYER_FACTION ? inspect_friendly_unit_draw : inspect_enemy_draw;
		} else if(_inst.entity_type == STRUCTURE){
			inspect_script = _inst.faction == PLAYER_FACTION ? inspect_friendly_structure_draw : inspect_enemy_draw;
		}
	}
	show_debug_message("inspecting: {0}", target);
}
function inspect_noone_draw(){
	// display mouse data
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_text(x+6, y+2, "camera location = [" + string(global.iCamera.x) + ", " + string(global.iCamera.y) + "] "+string(creator.zoom)+"\n" 
					+ creator.mouse_position_data_string + 
					"mouse focus = " + string(global.mouse_focus));
}
function inspect_friendly_unit_draw(){
	draw_sprite(target.sprite_index,target.image_index,x,y);
}
function inspect_friendly_structure_draw(){
	draw_sprite(target.sprite_index,target.image_index,x,y);
}
function inspect_enemy_draw(){
	draw_sprite(target.sprite_index,target.image_index,x,y);
}




enum INSPECTOR
{
	TYPE, // "text" or "image"
	POSITION, // vector 2
	DATA // will be a string or sprite index
}

//init the inspector
inspect(noone);

// set variables for drawing inspection data
inspection_list = ds_list_create();
function inspector_draw(){
	var _pos = undefined;
	var _data = undefined;
	for(var i=0;i<ds_list_size(inspection_list);i++)
	{
		_pos = inspection_list[| i][0];
		_data = inspection_list[| i][1]
	}
}




