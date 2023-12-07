/// @description 

shader_set(shWireHex);
SendWireHexVariables();
draw_self();
shader_reset();
var _listsize = ds_list_size(global.i_hex_grid.hexarr_containers[global.i_hex_grid.hex_get_index(grid_id.mouse_hex_coord)]);
// show the current hex cell of the mouse position
draw_text(mouse_x,mouse_y+10,
	controls_string+"["+string(mouse_x)+", "+string(mouse_y)+"]\n"
	+"["+string(grid_id.mouse_hex_coord[1])+", "+string(grid_id.mouse_hex_coord[2])+"] ("+string(current_index)+")\n"
	+"container size = ["+string(_listsize)+"]"
	);









