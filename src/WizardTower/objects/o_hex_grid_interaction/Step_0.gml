/// @description 

if(keyboard_check_pressed(hotkey_saveload)){
	var _exists = instance_exists(o_hex_grid_save_load_menu);
	with(o_hex_grid_save_load_menu) instance_destroy();
	if(!_exists) instance_create_layer(0,0,"Instances",o_hex_grid_save_load_menu);
}

if(instance_exists(o_hex_grid_save_load_menu)) exit;

// enable a node
if(mouse_check_button_pressed(mb_left))
{
	with(creator)
	{
		var ind = hexmap[? hex_get_key(mouse_hex_coord)];
		if(!is_undefined(ind)) && (hexarr_enabled[ind] == false)
		{
			// var hex = pixel_to_hex([2, mouse_x, mouse_y]);
			var ind = hexmap[? hex_get_key(mouse_hex_coord)];
			hex_enable_coord(mouse_hex_coord);
			show_debug_message("Enabled node {0}", mouse_hex_coord);
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
			var ind = hexmap[? hex_get_key(mouse_hex_coord)];
			if(!is_undefined(ind)) && (hexarr_enabled[ind] == true)
			{
				var hex = pixel_to_hex([2, mouse_x, mouse_y]);
				hex_disable_coord(hex);
				show_debug_message("Disabled node {0}", mouse_hex_coord);
			} else {
				show_debug_message("ERROR: cannot set disable hex node: {0}", mouse_hex_coord);
			}
		}
	}
}
if(keyboard_check_pressed(hotkey_setgoal)){
	with(creator) hex_set_goal(mouse_hex_coord);
	
} else if(keyboard_check_pressed(hotkey_remgoal)){
	with(creator) hex_remove_goal(mouse_hex_coord);
	
} else if(keyboard_check_pressed(hotkey_setspawn)){
	with(creator) hex_set_spawn(mouse_hex_coord);
	
} else if(keyboard_check_pressed(hotkey_remspawn)){
	with(creator) hex_remove_spawn(mouse_hex_coord);
	
}









