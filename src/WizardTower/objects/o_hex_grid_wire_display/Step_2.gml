/// @description 
with(o_hex_grid)
{
	other.x = mouse_hex_pos[1];
	other.y = mouse_hex_pos[2];
	
	var  ind = hexmap[? hex_get_key(mouse_hex_coord)];
	if(!is_undefined(ind))
	{
		other.current_index = ind;
	} else {
		other.current_index = -1;
	}
}
UpdateWireHexVariables();








