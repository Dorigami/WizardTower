/// @description 

if(!instance_exists(o_hex_grid)) || (alarm[0] > -1) exit;
mouse_pos[1] = mouse_x;
mouse_pos[2] = mouse_y;

// convert hex indexes to position vectors
with(global.i_hex_grid)
{
	var _line = get_hexes_in_line(other.position, other.mouse_pos);
	array_resize(other.line_arr,array_length(_line));
	
	for(var i=0; i<array_length(_line); i++)
	{
		other.line_arr[i] = hex_to_pixel(_line[i], true);
	}
}

//show_debug_message("distance = {0}", axial_distance(position, ))
show_debug_message("line arr = {0}", line_arr);





