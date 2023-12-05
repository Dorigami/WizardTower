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






