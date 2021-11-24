/// @description 

draw_set_color(c_white);
draw_set_alpha(1);
if(state != STATE.SPAWN)
{
	if(shadowEnabled) draw_sprite_ext(sShadow,0,floor(x),floor(y),shadowScale,shadowScale,0,c_white,1);

	if(flash != 0)
	{   // set shader
		shader_set(flashShader); uFlash = shader_get_uniform(flashShader, "flash"); shader_set_uniform_f(uFlash, flash);
		// draw flashing entity
		draw_sprite_ext( sprite_index,image_index,floor(x),floor(y-z),image_xscale,image_yscale,image_angle,image_blend,image_alpha);
	} else {
		// draw entity normally
		draw_sprite_ext( sprite_index,image_index,floor(x),floor(y-z),image_xscale,image_yscale,image_angle,image_blend,image_alpha);
	}

	// reset shader
	if(shader_current() != -1) shader_reset();
} else {

		// draw entity normally (transparent)
		draw_sprite_ext(sprite_index,
						image_index,
						floor(x),
						floor(y-z),
						image_xscale,
						image_yscale,
						image_angle,
						image_blend,
						image_alpha
						);
		// draw opaque sprite as building progresses
		draw_set_alpha(1);
		var _hgt = floor(sprite_height*buildProgress);
		draw_sprite_part(sprite_index,
						 image_index,
						 0,
						 sprite_height-_hgt,
						 sprite_width,
						 _hgt,
						 floor(x)-sprite_get_xoffset(sprite_index),
						 floor(y-z)+sprite_height-sprite_get_yoffset(sprite_index)-_hgt,
						 );
}

//draw_text(x+20,y-40,"alarm[0] = " + string(alarm[0]) 
//			   + "\n"+script_get_name(stateScript[state])
//			   + "\n"+string(image_alpha)  
//);
//if(ds_exists(builderList, ds_type_list))
//{
//	draw_text(x-60,y,"list " + string(ds_list_size(builderList)) + "\nProg: " + string(buildProgress));
//}