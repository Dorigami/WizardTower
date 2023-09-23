/// @description 

if(gui)
{
	var _x = x+0.5*sprite_width;
	var _y = y+0.5*sprite_height;
	
	draw_self();

	draw_set_font(fDefault);
	draw_set_color(textColor);
	draw_set_alpha(image_alpha);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_sprite(global.iEngine.current_player_abilities[action_index].icon,0,_x,_y);
	draw_text_ext(_x,_y + textOffsetY, text, 10, 0.9*sprite_width);
}