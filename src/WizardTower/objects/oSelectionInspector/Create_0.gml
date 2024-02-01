/// @description 

function inspect(_inst){
	target = _inst;
	inspect_draw_script = inspector_draw;
	if(_inst == noone){
		inspect_update_script = inspect_noone_step;
		ds_list_clear(inspection_list);
		// create the struct that will allow the data inside to be drawn to the screen
		var _data = [vect2(x+6,y+2),""];
		ds_list_add(inspection_list,_data);
	} else {
	//--// check if the entity is a blueprint
		if(!is_undefined(_inst.blueprint))
		{
			ds_list_clear(inspection_list);
			var _data = [
				[vect2(x+30,y+(inspection_bbox[3]-inspection_bbox[1]) div 2), [_inst.sprite_index, _inst.image_index]],  // sprite image
				[vect2(x+60,y+3), _inst.name],                                                        // name
			];

			// add all the data defined previously to the inspection list
			for(var i=0;i<array_length(_data);i++){ ds_list_add(inspection_list, _data[i]) }
		} else {
	//--// then check if it is anything else
		if(_inst.entity_type == UNIT){
			inspect_update_script = _inst.faction == PLAYER_FACTION ? inspect_friendly_unit_step : inspect_enemy_step;
		} else if(_inst.entity_type == STRUCTURE){
			inspect_update_script = _inst.faction == PLAYER_FACTION ? inspect_friendly_structure_step : inspect_enemy_step;
		}
		ds_list_clear(inspection_list);
		// create an array containing all data required to be displayed
		var _fighter = _inst.fighter;
		var _data = [
			[vect2(x+30,y+(inspection_bbox[3]-inspection_bbox[1]) div 2), [_inst.sprite_index, _inst.image_index]],  // sprite image
			[vect2(x+60,y+3), _inst.name],                                                        // name
			[vect2(x+60,y+20), "HP: " + string(_fighter.hp) + " / " + string(_fighter.hp_max)],   // health
			[vect2(x+60,y+30), "DEF: " + string(_fighter.defense)],                               // defense
			[vect2(x+60,y+40), _fighter.basic_attack == -1 ? "STR: ---" : "STR: " + string(_fighter.strength)],                              // strength
			[vect2(x+60,y+50), _fighter.basic_attack == -1 ? "RATE: ---" : "RATE: "+string(FRAME_RATE / _fighter.basic_attack.cooldown)],   // attack rate
			[vect2(x+120,y+30), "kills: " + string(_fighter.kill_count)] // kill count
		];

		// add all the data defined previously to the inspection list
		for(var i=0;i<array_length(_data);i++){ ds_list_add(inspection_list, _data[i]) }
		}
	}
}
function inspect_noone_step(){
	var  _data = inspection_list[| 0];
	if(is_undefined(_data)) exit;
	_data[1] = "camera location = [" + string(global.iCamera.x) + ", " + string(global.iCamera.y) + "] "+string(global.iEngine.zoom)+"\n" 
					+ creator.mouse_position_data_string + 
					"mouse focus = " + string(global.mouse_focus) + "\n" +
					"HUD Focus = " + string(global.hud_focus);
}
function inspect_blueprint_step(){
	inspection_list[| 0][1][1] = target.image_index; 
//  inspection_list[| 1] 'name' does not need to update
}
function inspect_friendly_unit_step(){
	var _fighter = target.fighter;
	inspection_list[| 0][1][1] = target.image_index;                                                                            // sprite image
//  inspection_list[| 1] 'name' does not need to update
	inspection_list[| 2][1] = "HP: " + string(_fighter.hp) + " / " + string(_fighter.hp_max);                                   // health
	inspection_list[| 3][1] = "DEF: " + string(_fighter.defense);                                                               // defense
	inspection_list[| 4][1] = _fighter.basic_attack == -1 ? "STR: ---" : "STR: " + string(_fighter.strength);                   // strength
	inspection_list[| 5][1] = _fighter.basic_attack == -1 ? "RATE: ---" : "RATE: " + string(1 / _fighter.basic_attack.cooldown);// attack rate
	inspection_list[| 6][1] = "Kills: " + string(_fighter.kill_count);
}
function inspect_friendly_structure_step(){
	var _fighter = target.fighter;
	inspection_list[| 0][1][1] = target.image_index;                                            // sprite image
//  inspection_list[| 1] 'name' does not need to update
	inspection_list[| 2][1] = "HP: " + string(_fighter.hp) + " / " + string(_fighter.hp_max);   // health
	inspection_list[| 3][1] = "DEF: " + string(_fighter.defense);                                                               // defense
	inspection_list[| 4][1] = _fighter.basic_attack == -1 ? "STR: ---" : "STR: " + string(_fighter.strength);                   // strength
	inspection_list[| 5][1] = _fighter.basic_attack == -1 ? "RATE: ---" : "RATE: " + string(1 / _fighter.basic_attack.cooldown);// attack rate
	inspection_list[| 6][1] = "Kills: " + string(_fighter.kill_count);
}
function inspect_enemy_step(){
	var _fighter = target.fighter;
	inspection_list[| 0][1][1] = target.image_index;                                            // sprite image
//  inspection_list[| 1] 'name' does not need to update
	inspection_list[| 2][1] = "HP: " + string(_fighter.hp) + " / " + string(_fighter.hp_max);   // health
	inspection_list[| 3][1] = "DEF: " + string(_fighter.defense);                                                               // defense
	inspection_list[| 4][1] = _fighter.basic_attack == -1 ? "STR: ---" : "STR: " + string(_fighter.strength);                   // strength
	inspection_list[| 5][1] = _fighter.basic_attack == -1 ? "RATE: ---" : "RATE: " + string(1 / _fighter.basic_attack.cooldown);// attack rate
	inspection_list[| 6][1] = "Kills: " + string(_fighter.kill_count);
}

// set variables for drawing inspection data
inspection_list = ds_list_create();
inspection_bbox = [x,y,x+223,y+72];
function inspector_draw(){
	var _pos = undefined;
	var _data = undefined;
	draw_set_alpha(image_alpha);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	draw_set_font(fDefault);	
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


//init the inspector
inspect(noone);





