/// @description 
if(damage_point_timer > 0) && (image_number_start > image_index)
{
	show_debug_message("start sprite");
	draw_sprite_ext(spr_start,image_index,x,y,image_xscale,image_yscale,image_angle,image_blend,image_alpha);
}
if(damage_point_timer <= 0) && (image_number_end > image_index)
{
	show_debug_message("end sprite");
	draw_sprite_ext(spr_end,image_index,xend,yend,end_scale,end_scale,image_angle,image_blend,image_alpha);
}

