/// @description 
var _player = actor_list[| PLAYER_FACTION];
var _size = ds_list_size(_player.selected_entities);
var _str = "", _ind = 0;

draw_set_font(fNode);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_green);

var _arr = ["PAUSE", "PLAY", "BUILDING", "SELLING","TARGETING", "VICTORY", "DEFEAT", "MAIN_MENU", "UPGRADE_MENU"];
_str = _arr[global.game_state];
draw_text(0, 8, "GAME STATE: " + _str);

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
