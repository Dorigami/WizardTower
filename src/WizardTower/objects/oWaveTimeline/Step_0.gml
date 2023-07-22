/// @description 

if(global.game_state = GameStates.PLAY)
{
	if(!timeline_running) timeline_running = true;
	// check if the wave enemies are still alive 
	var _size = ds_list_size(entity_list);
	if(_size > 0)
	{
		for(var i=_size-1; i>=0; i--)
		{
			var _enemy = entity_list[| i];
			// if there is no enemy, or the enemies index is mismatched with the global entity list, remove this reference from the wave
			if(is_undefined(_enemy)) || (!instance_exists(_enemy))
			{
				ds_list_delete(entity_list, i);
			}
		}
	} else {
		if(moment_index >= moment_count)
		{
			// let the actor know that the wave has ended
			owner.ai.wave_has_ended = true;
			wave_data.instance = noone;
			wave_data.complete = true;
			instance_destroy();
		}
	}
} else {
	if(timeline_running) timeline_running = false;
}
