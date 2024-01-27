/// @description 

function inspect(_inst){
	target = _inst;
	inspect_draw_script = inspector_draw;
	if(_inst == noone){
		inspect_update_script = inspect_noone_step;
	} else {
		if(_inst.entity_type == UNIT){
			inspect_update_script = _inst.faction == PLAYER_FACTION ? inspect_friendly_unit_step : inspect_enemy_step;
		} else if(_inst.entity_type == STRUCTURE){
			inspect_update_script = _inst.faction == PLAYER_FACTION ? inspect_friendly_structure_step : inspect_enemy_step;
		}
	}
	show_debug_message("inspecting: {0}", target);
}
function inspect_noone_step(){
	// display mouse data
	draw_set_valign(fa_top);
	draw_set_halign(fa_left);
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_text(x+6, y+2, "camera location = [" + string(global.iCamera.x) + ", " + string(global.iCamera.y) + "] "+string(creator.zoom)+"\n" 
					+ creator.mouse_position_data_string + 
					"mouse focus = " + string(global.mouse_focus));
}
function inspect_friendly_unit_step(){
	draw_sprite(target.sprite_index,target.image_index,x,y);
}
function inspect_friendly_structure_step(){
	draw_sprite(target.sprite_index,target.image_index,x,y);
}
function inspect_enemy_step(){
	draw_sprite(target.sprite_index,target.image_index,x,y);
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
		_data = inspection_list[| i][1];
		if(is_string(_data))
		{ // the data is simple text to be drawn
			draw_text(_pos[1], _pos[2], _data);
		} else {
		  // the only other type of data would be a sprite index and image index
			draw_sprite(_data[0], _data[1], _pos[1], _pos[2]);
		}
	}
}




