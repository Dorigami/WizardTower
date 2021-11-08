/// @description 

if(highlight) || (selected){
	if(con_game.selection_type_ = "single")
	{
		draw_set_alpha(0.5);
		draw_circle(x,y,range_,true);
		draw_set_alpha(1);
	}
	// outline the unit
	shader_set(sh_outline);
	shader_set_uniform_f(upixelW, texelW);
	shader_set_uniform_f(upixelH, texelH);
	draw_self();
	shader_reset();
	//if(path_exists(path_) && path_position < 1) draw_path(path_,x,y,true);
} else {
	draw_self();
}

if
{
	draw_sprite_ext(sprite_index,0,x,y,image_xscale,image_yscale,0,c_white,0.2);
}
if(unitSpriteIndex != -1) && (unitSpriteIndex != sHighlight)
{
	draw_sprite_ext(unitSpriteIndex,unitImageIndex,x,y,1,1,0,c_white,image_alpha);
}
