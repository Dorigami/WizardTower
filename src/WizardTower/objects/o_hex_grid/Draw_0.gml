/// @description Insert description here
// You can write your code in this editor

shader_set(shWireHex);

SendWireHexVariables();

draw_sprite(sWireHex, 0, x, y);

shader_reset();


// show the current hex cell of the mouse position
if(keyboard_check(vk_alt))
{
	draw_text(mouse_x,mouse_y+10,"["+string(mouse_hex_coord[1])+", "+string(mouse_hex_coord[2])+"]")
}
