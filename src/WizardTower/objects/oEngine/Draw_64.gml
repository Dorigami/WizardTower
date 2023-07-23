/// @description 
var _player = actor_list[| PLAYER_FACTION];
var _size = ds_list_size(_player.selected_entities);
var _str = "", _ind = 0;

draw_set_font(fNode);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_green);

var _arr = ["PAUSE", "PLAY", "BUILDING", "TARGETING", "VICTORY", "DEFEAT", "MAIN_MENU", "UPGRADE_MENU"];
_str = _arr[global.game_state];
draw_text(0, 0, "GAME STATE: " + _str);

if(global.game_state == GameStates.PAUSE)
{
	draw_set_color(c_black);
	draw_set_alpha(0.3);
	with(global.iCamera) draw_rectangle(0, 0, 2*viewWidthHalf, 2*viewHeightHalf, false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	// show 'pause text'
	draw_text(350, 160, "GAME PAUSED");
	// display keybinds
	draw_text(5, 15, keybinds_string);

} else {
	draw_set_color(c_white);
	draw_set_alpha(1);
	_str = "";
	with(_player)
	{
		// show player health
		_str += "HEALTH: " + string(health) + "\n";
		// show unit supply
		_str += "SUPPLY: " + string(supply_current+supply_in_queue) + " / " + string(supply_limit) + "\n";
		// show available material
		_str += "MATERIAL: [+"+string(material_per_second)+"] "+string(material)+"\n";
		// show available material
		_str += "EXPERIENCE: "+string(experience_points)+"\n";
		// show upgrade points
		_str += "UPGRADE: " + string(upgrade_points) + "\n";
	}
	// display abilities available
	for(i=0;i<3;i++)
	{
		_ind = i*3;
		_str += "ability " + string(_ind+1) + "[" + ability_hotkeys[_ind] + "] = " + available_abilities_arr[_ind] + "  |  ";
		_str += string(_ind+2) + "[" + ability_hotkeys[_ind+1] + "] = " + available_abilities_arr[_ind+1] + "  |  ";
		_str += string(_ind+3) + "[" + ability_hotkeys[_ind+2] + "] = " + available_abilities_arr[_ind+2] + "\n";
	}
	draw_text(5,15,_str);
	// display mouse data
	draw_text(180,10, "camera location = [" + string(global.iCamera.x) + ", " + string(global.iCamera.y) + "] "+string(zoom)+"\n" 
					+ "mouse location = [" + string(mouse_x) + ", " + string(mouse_y) + "] [" 
					+ string(mouse_x div GRID_SIZE) + ", " + string(mouse_y div GRID_SIZE) + "]\n mouse focus = " 
					+ string(global.mouse_focus));

	// show enemy wave status
	var enemy_actor = actor_list[| 1];
	if(!is_undefined(enemy_actor)) && (!is_undefined(enemy_actor.ai))
	{
		draw_text(500,30,"Wave Index = " + string(enemy_actor.ai.wave_index+1) + " / " + string(array_length(enemy_actor.ai.wave_keys)) 
					+ "\nWave Timer = " + string(enemy_actor.ai.wave_timer)
					);	
	}
//--// show info about the PLAYER ACTOR
	_str = "";

	// show entity selection
	_str += "selection count: " + string(_size) +"\n";
	if(_size > 0)
	{
		for(var i=0; i<_size; i++)
		{
			var _ent = _player.selected_entities[| i];
			if(instance_exists(_ent))
			{
				_str += object_get_name(_ent.object_index)+" : HP = " + string(_ent.fighter.hp) + "\n";
			}
		}
		draw_text(global.iCamera.viewWidthHalf,5,_str);
	}
}
