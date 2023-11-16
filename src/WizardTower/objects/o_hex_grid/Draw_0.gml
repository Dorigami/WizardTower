/// @description Insert description here
// You can write your code in this editor

shader_set(shWireHex);
shader_set_uniform_f(umouseX, texelW*(mouse_hex_pos[1] - mouse_x));
shader_set_uniform_f(umouseY, texelH*(mouse_hex_pos[2] - mouse_y));
shader_set_uniform_f(uresW, texelW*wire_width);
shader_set_uniform_f(uresH, texelH*wire_height);
draw_sprite(sWireHex, 0, mouse_hex_pos[1], mouse_hex_pos[2]);
shader_reset();
