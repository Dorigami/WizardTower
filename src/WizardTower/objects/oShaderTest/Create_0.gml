/// @description Initialize Variables


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


#macro RESOLUTION_W sprite_get_width(sprite_index)
#macro RESOLUTION_H sprite_get_height(sprite_index)

with(global.iEngine)
{
	InitializeDisplay(1);
}
var i = 0;
while(room_exists(i))
{
	show_debug_message("setting the room")
	room_set_height(i, RESOLUTION_H);
	room_set_width(i, RESOLUTION_W);
	i++;
}
alarm[0] = 1;

// shader stuff
upixelH = shader_get_uniform(sh_outline, "pixelH");
upixelW = shader_get_uniform(sh_outline, "pixelW");
uresW = shader_get_uniform(sh_tutorial, "resW");
uresH = shader_get_uniform(sh_tutorial, "resH");
uTime = shader_get_uniform(sh_tutorial, "iTime");
texelW = texture_get_texel_width(sprite_get_texture(sprite_index,0));
texelH = texture_get_texel_height(sprite_get_texture(sprite_index,0));
shader_draw_script = tutorial_shader_draw;
my_custom_shader_create();

