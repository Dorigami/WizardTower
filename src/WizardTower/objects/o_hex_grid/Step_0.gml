/// @description 

// update hex position for the mouse
mouse_hex_coord = pixel_to_hex([2, mouse_x, mouse_y]);
mouse_hex_pos = hex_to_pixel(mouse_hex_coord, true);

if(keyboard_check_pressed(vk_alt))
{
	instance_create_layer(0,0,"Instances",o_hex_grid_wire_display)
} else {
	if(keyboard_check_released(vk_alt))
	{
		with(o_hex_grid_wire_display) instance_destroy();
	}
}


