/// @description 

shader_set(shWireHex);
SendWireHexVariables();
draw_self();
shader_reset();

// show the current hex cell of the mouse position
draw_text(mouse_x,mouse_y+10,"["+string(grid_id.mouse_hex_coord[1])+", "+string(grid_id.mouse_hex_coord[2])+"]")









