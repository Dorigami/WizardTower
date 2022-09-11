/// @description 

draw_set_color(c_white);
draw_set_alpha(1);

if(global.iUI.targetClick) && (global.iUI.targetHover == id)
{
	draw_set_alpha(0.1)
	draw_set_color(global.iGame.color7);
	draw_circle(x+16,y+16,range*TILE_SIZE,false);
	draw_set_alpha(1)
}

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

if(global.iUI.targetHover == id)
{
	// outline the entity
	shader_set(shOutline);
	shader_set_uniform_f(upixelW, texelW);
	shader_set_uniform_f(upixelH, texelH);
	draw_sprite_ext(sprite_index,image_index,x,y,1,1,0,c_white,image_alpha);
	shader_reset();
}

//draw_text(x,y-40,"0: " + string(cdTimer) + "\n1: " + string(alarm[1]) + "  size: " + string(ds_list_size(targetList)));
//draw_circle(x+0.5*TILE_SIZE,y+0.5*TILE_SIZE,range*TILE_SIZE,true);

//draw_text(x+20,y-40,"alarm[0] = " + string(alarm[0]) 
//			   + "\n"+script_get_name(stateScript[state])
//			   + "\n"+string(image_alpha)  
//);
//if(ds_exists(builderList, ds_type_list))
//{
//	draw_text(x-60,y,"list " + string(ds_list_size(builderList)) + "\nProg: " + string(buildProgress));
//}