/// @description 

if(shadowEnabled) draw_sprite_ext(sShadow,0,floor(x),floor(y),shadowScale,shadowScale,0,c_white,1);

if(selected){
	// outline the entity
	shader_set(shOutline);
	shader_set_uniform_f(upixelW, texelW);
	shader_set_uniform_f(upixelH, texelH);
	draw_sprite_ext(sprite_index,image_index,x,y-z,1,1,0,c_white,image_alpha);
	// show flash on entity
	if(flash != 0)
	{   // set shader
		shader_set(flashShader); uFlash = shader_get_uniform(flashShader, "flash"); shader_set_uniform_f(uFlash, flash);
		// draw flashing entity
		draw_sprite_ext( sprite_index,image_index,floor(x),floor(y-z),image_xscale,image_yscale,image_angle,image_blend,image_alpha);
	}
} else {
	if(flash != 0)
	{   // set shader
		shader_set(flashShader); uFlash = shader_get_uniform(flashShader, "flash"); shader_set_uniform_f(uFlash, flash);
		// draw flashing entity
		draw_sprite_ext( sprite_index,image_index,floor(x),floor(y-z),image_xscale,image_yscale,image_angle,image_blend,image_alpha);
	} else {
		// draw entity normally
		draw_sprite_ext( sprite_index,image_index,floor(x),floor(y-z),image_xscale,image_yscale,image_angle,image_blend,image_alpha);
	}
}
// reset shader
if(shader_current() != -1) shader_reset();

