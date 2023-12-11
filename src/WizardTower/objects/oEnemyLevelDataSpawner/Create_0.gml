/// @description 

check_time = 10;
check_timer = 1;
with(global.i_hex_grid)
{
	if(ds_list_size(hexgrid_spawn_list) == 0)
	{
		show_debug_message("Error: enemy spawner, there aren't any places to spawn enemies");
		instance_destroy(other);
	} else {
		other.hex_index = hexgrid_spawn_list[| min(other.spawn_node_index, ds_list_size(hexgrid_spawn_list))]
		other.hex_position = hexarr_positions[other.hex_index];
	}
}


//--// get power values and spawn count for each unit type
// the array for power values must be one index shorter than spawn data because the 
// first element is used to indicate the node to spawn at
power_by_type = ds_map_create();
spawn_list = ds_list_create();
spawn_list_count = 0;
for(var i=0;i<array_length(spawn_data);i++)
{
	if(is_array(spawn_data[i]))
	{
		// update ds_map with the power value for the given unit type
		ds_map_add(power_by_type, spawn_data[i][0], spawn_data[i][2]);
		// add to the spawn list, this will be used to spawn units onto the playspace
		repeat(spawn_data[i][1]){ ds_list_add(spawn_list, spawn_data[i][0]); }
	}
}
spawn_list_count = ds_list_size(spawn_list);



