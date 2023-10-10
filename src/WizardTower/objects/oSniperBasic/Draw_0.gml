/// @description 
if(image_index < image_number_start)
{
	show_debug_message("start sprite");
	draw_sprite_ext(spr_start,image_index,x,y,start_scale,0.6,image_angle,image_blend,image_alpha);
}
if(image_index < image_number_end)
{
	show_debug_message("end sprite");
	draw_sprite_ext(spr_end,image_index,xend,yend,image_xscale,image_yscale,image_angle,image_blend,image_alpha);
}



