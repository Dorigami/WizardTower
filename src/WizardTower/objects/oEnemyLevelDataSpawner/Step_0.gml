/// @description 

/*
	REMEMBER TO IGNORE THE FIRST INDEX IN spawn_data AS THAT IS THE INDEX FOR THE HEX NODE TO SPAWN INTO
*/

// check for creator
if(!instance_exists(owner))
{
	instance_destroy();
	exit;
}

if(global.game_state != GameStates.PLAY) exit;
var _size = ds_list_size(spawn_list);
if(--check_timer == 0)
{
	//reset timer
	check_timer = check_time;
	// get the index for the given hex node where the enemies will spawn
	if(_size > 0)
	{
		var _inst = instance_place(hex_position[1], hex_position[2],pEntity);
		if(_inst == noone)
		{
			// get data
			var _type = spawn_list[| 0];
			var _power = power_by_type[? _type];
			// spawn the enemy
			var _unit = ConstructUnit(hex_position[1], hex_position[2], ENEMY_FACTION, _type);
			// give the timeline manager a reference to the enemy
			ds_list_add(owner.entity_list, _unit);	
			// remove from the spawn list
			ds_list_delete(spawn_list, 0);
		}
	}
}

