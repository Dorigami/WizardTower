/// @description 
if(sprite_index != -1)
{
	draw_sprite_ext(sprite_index, 
	                image_index, 
					x, 
					y, 
					image_xscale, 
					image_yscale, 
					0, 
					image_blend, 
					image_alpha
					);
}
if(controlsCount > 0)
{
	for(var i=0; i<controlsCount; i++)
	{
		var _ctrl = controlsList[| i];
		_ctrl.Draw();
	}
}

/*
if(!gui)
{
	

	draw_set_font(fDefault);
	draw_set_color(textColor);
	draw_set_alpha(image_alpha);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text_ext(x+0.5*sprite_width,y+0.5*sprite_height + textOffsetY, text, 20, 0.9*sprite_width);
}