/// @description 

if(!instance_exists(o_hex_grid)) exit;
mouse_pos[1] = mouse_x;
mouse_pos[2] = mouse_y;

// get hexes for each hex node in the line
line_arr = axial_linedraw(position, mouse_pos);

// convert hex indexes to position vectors
with(global.i_hex_grid)
{
	for(var i=0;i<array_length(other.line_arr);i++)
	{
		other.line_arr[i] = hex_to_pixel(other.line_arr[i], true);
	}
}

show_debug_message("distance = {0}", axial_distance(position, ))
show_debug_message("line arr = {0}", line_arr);





