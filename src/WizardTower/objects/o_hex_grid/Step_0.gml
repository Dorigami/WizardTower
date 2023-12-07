/// @description 

// update hex position for the mouse
mouse_hex_coord = pixel_to_hex([2, mouse_x, mouse_y]);
mouse_hex_pos = hex_to_pixel(mouse_hex_coord, true);

if(keyboard_check_pressed(vk_alt))
{
	instance_create_depth(0,0,depth-1,o_hex_grid_wire_display)
} else {
	if(keyboard_check_released(vk_alt))
	{
		with(o_hex_grid_wire_display) instance_destroy();
	}
}

// check for enemies that get to any of the spawn nodes, then deal damage to the player if they have made it
var _size = ds_list_size(hexgrid_goal_list);
if(_size > 0)
{
	// loop over each goal node
	for(var ind=0;ind<_size;ind++)
	{
		var _goal_index = hexgrid_goal_list[| ind];
		// check ti see if any enemies are in the node
		if(){}
	}
}



