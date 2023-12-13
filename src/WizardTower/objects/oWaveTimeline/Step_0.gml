/// @description 

if(global.game_state = GameStates.PLAY)
{	
	// show_debug_message("wave {0} progress = {1} | running = {2}", wave_index, timeline_position, timeline_running);
	if(wave_data.complete) exit;
	if(!timeline_running) timeline_running = true;
	// check if the wave enemies are still alive 
	var _entity_count = ds_list_size(entity_list);
	var _spawner_count = ds_list_size(spawner_list);
	for(var i=_entity_count-1; i>=0; i--)
	{
		var _enemy = entity_list[| i];
		// if there is no enemy, or the enemies index is mismatched with the global entity list, remove this reference from the wave
		if(is_undefined(_enemy)) || (!instance_exists(_enemy)){ ds_list_delete(entity_list, i); }
	}
	for(var i=_spawner_count-1; i>=0; i--)
	{   // loop through each existing spawner for the wave
		with(spawner_list[| i])
		{   // if the spawner has no units left to spawn, destroy it
			if(ds_list_size(spawn_list) == 0)
			{
				ds_list_delete(other.spawner_list, i);
				instance_destroy();
			}
		}
	}
	
	// destroy self once all enemies in the wave have been defeated, 
	// also let the enemy controller know that this wave is complete
	if(_entity_count == 0) && (_spawner_count == 0) && (moment_index >= moment_count) && (!wave_data.complete)
	{
		//show_debug_message("Wave {0} has ended", wave_index);
		owner.wave_has_ended = true;
		wave_data.complete = true;
		wave_data.instance = noone;
	}
} else {
	if(timeline_running) timeline_running = false;
}
