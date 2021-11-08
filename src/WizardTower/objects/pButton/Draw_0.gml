/// @description 

if(!gui)
{
	draw_self();

	draw_set_font(fText);
	draw_set_color(textColor);
	draw_set_alpha(image_alpha);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text_ext(x+0.5*sprite_width,y+0.5*sprite_height + textOffsetY, text, 20, 0.9*sprite_width);
}