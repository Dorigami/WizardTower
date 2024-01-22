/// @description 

if(gui)
{
	var _x = x+0.5*sprite_width;
	var _y = y+0.5*sprite_height;
	var _ability = global.iEngine.current_player_abilities[action_index];
	draw_self();

	draw_set_font(fDefault);
	draw_set_color(textColor);
	draw_set_alpha(image_alpha);
	draw_set_valign(fa_middle);
	draw_sprite(_ability.icon,0,x,y);
	/* i only need the icon drawn don't draw the text included below
	if(!is_undefined(_ability.values[$ "cost"]))
	{
		draw_set_halign(fa_left);
		draw_text_ext(x,_y+20, text + " $" + string(_ability.values[$ "cost"]), 10, 0.9*sprite_width);
	} else {
		draw_set_halign(fa_center);
		draw_text_ext(_x, _y+20, text, 10, 0.9*sprite_width);
	}
	*/
}