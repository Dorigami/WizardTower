/// @description 

/*
	REMEMBER TO IGNORE THE FIRST INDEX IN spawn_data AS THAT IS THE INDEX FOR THE HEX NODE TO SPAWN INTO
*/

if(global.game_state != GameStates.PLAY) exit;

if(--check_timer == 0)
{
	//reset timer
	check_timer = check_time;
	// get the index for the given hex node where the enemies will spawn
	var _inst = instance_place(hex_position[1], hex_position[2],pEntity);
	if(_inst == noone)
	{
		// spawn the enemy
		var _unit = ConstructUnit(hex_position[1], hex_position[2], ENEMY_FACTION, spawn_data[++spawn_index][0]);
		// give the timeline manager a reference to the enemy
		ds_list_add(owner.entity_list, _unit);	
	}
}

// destroy self when all of the enemies have been spawned in
if(spawn_index == array_length(spawn_data)-1)
{
	instance_destroy();
}







