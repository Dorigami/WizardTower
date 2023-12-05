/// @description 

if(global.game_state = GameStates.PLAY)
{
	if(!timeline_running) timeline_running = true;
	// check if the wave enemies are still alive 
	var _size0 = ds_list_size(entity_list);
	var _size1 = ds_list_size(spawner_list);
	if(_size0 > 0) || (_size1 > 0)
	{
		for(var i=_size0-1; i>=0; i--)
		{
			var _enemy = entity_list[| i];
			// if there is no enemy, or the enemies index is mismatched with the global entity list, remove this reference from the wave
			if(is_undefined(_enemy)) || (!instance_exists(_enemy))
			{
				ds_list_delete(entity_list, i);
			}
		}
		for(var i=_size1-1; i>=0; i--)
		{
			var _inst = spawner_list[| i];
			// if there is no enemy, or the enemies index is mismatched with the global entity list, remove this reference from the wave
			if(is_undefined(_inst)) || (!instance_exists(_inst))
			{
				ds_list_delete(spawner_list, i);
			}
		}
	} else {
		if(moment_index >= moment_count)
		{
			// let the actor know that the wave has ended
			owner.wave_has_ended = true;
			var _wave_content = owner.wave_structs_list[| wave_index];
			_wave_content.complete = true;
			_wave_content.instance = noone;
			instance_destroy();
		}
	}
} else {
	if(timeline_running) timeline_running = false;
}
