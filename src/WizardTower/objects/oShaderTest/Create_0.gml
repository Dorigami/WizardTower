/// @description Initialize Variables
/*
The Tower is the object that does pew pew on the enemies
*/

#macro RESOLUTION_W sprite_get_width(sprite_index)
#macro RESOLUTION_H sprite_get_height(sprite_index)

InitializeDisplay(RESOLUTION_W div RESOLUTION_H);

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

