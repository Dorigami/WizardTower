/// @description 

// enable a node
if(mouse_check_button_pressed(mb_left))
{
	with(creator)
	{
		if(!is_undefined(hexmap[? hex_get_key(mouse_hex_coord)]))
		{
			// var hex = pixel_to_hex([2, mouse_x, mouse_y]);
			show_debug_message("node enabled at: {0} | {1}  |  hex position = {2}", mouse_hex_coord, mouse_hex_pos, hexarr_positions[hex_get_key(mouse_hex_coord)]);
			hex_enable_coord(mouse_hex_coord);
		} else {
			show_debug_message("ERROR: cannot set enable hex node: {0}", mouse_hex_coord);
		}
	}
} else {
// diable a node
	if(mouse_check_button_pressed(mb_right))
	{
		with(creator)
		{
			if(!is_undefined(hexmap[? hex_get_key(mouse_hex_coord)]))
			{
				var hex = pixel_to_hex([2, mouse_x, mouse_y]);
				hex_disable_coord(hex);
			} else {
				show_debug_message("ERROR: cannot set disable hex node: {0}", mouse_hex_coord);
			}
		}
	}
}
if(mouse_wheel_up()){

}









