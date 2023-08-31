// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function my_custom_shader_create(){
	// shader stuff
	umouseX = shader_get_uniform(sh_custom, "mouseX");
	umouseY = shader_get_uniform(sh_custom, "mouseY");
	uresW = shader_get_uniform(sh_custom, "resW");
	uresH = shader_get_uniform(sh_custom, "resH");
	uTime = shader_get_uniform(sh_custom, "iTime");
	texelW = texture_get_texel_width(sprite_get_texture(sprite_index,0));
	texelH = texture_get_texel_height(sprite_get_texture(sprite_index,0));
	shader_draw_script = my_custom_shader_draw;
}
function my_custom_shader_draw(){
	shader_set(sh_custom);
	shader_set_uniform_f(umouseX, texelW*mouse_x);
	shader_set_uniform_f(umouseY, texelH*mouse_y);
	shader_set_uniform_f(uresW, texelW*RESOLUTION_W);
	shader_set_uniform_f(uresH, texelH*RESOLUTION_H);
	shader_set_uniform_f(uTime, current_time*0.001);
	draw_self();
	shader_reset();
}
function tutorial_shader_draw(){
	shader_set(sh_tutorial);
	//shader_set_uniform_f(upixelW, texelW);
	//shader_set_uniform_f(upixelH, texelH);
	shader_set_uniform_f(uresW, texelW*RESOLUTION_W);
	shader_set_uniform_f(uresH, texelH*RESOLUTION_H);
	shader_set_uniform_f(uTime, current_time*0.001);
	draw_self();
	shader_reset();
}