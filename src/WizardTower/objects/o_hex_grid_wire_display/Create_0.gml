/// @description 

grid_id = noone;
with(o_hex_grid) other.grid_id = id;


sprite_tex = sprite_get_texture(sprite_index,0);
umouseX = shader_get_uniform(shWireHex, "mouseX");
umouseY = shader_get_uniform(shWireHex, "mouseY");
texelW = texture_get_texel_width(sprite_get_texture(sprite_index,0));
texelH = texelW*1.2675;//texture_get_texel_height(sprite_get_texture(sprite_index,0));
uresW = shader_get_uniform(shWireHex, "resW");
uresH = shader_get_uniform(shWireHex, "resH");

mouse_uv = vect2(0,0);
wire_width = texelW * sprite_get_width(sprite_index);
wire_height = texelH * sprite_get_height(sprite_index);
function UpdateWireHexVariables(){
	mouse_uv[1] = texelW*(mouse_x-x);
	mouse_uv[2] = texelH*(mouse_y-y);
}
function SendWireHexVariables(){
	shader_set_uniform_f(umouseX, mouse_uv[1]);
	shader_set_uniform_f(umouseY, mouse_uv[2]);
	shader_set_uniform_f(uresW, wire_width);
	shader_set_uniform_f(uresH, wire_height);
}








