/// @description 

/*

if(highlight) || (selected)
{
	draw_sprite_ext(sprite_index,0,x,y,image_xscale,image_yscale,0,c_white,0.2);
}
if(unitSpriteIndex != -1) && (unitSpriteIndex != sHighlight)
{
	draw_sprite_ext(unitSpriteIndex,unitImageIndex,x,y,1,1,0,c_white,image_alpha);
}
if(showBars) || (selected)
{
	draw_set_alpha(0.6);
	
	var _x = x-0.5*(sprite_get_width(barSpriteIndex)-sprite_get_xoffset(barSpriteIndex));
	var _y = y-size-sprite_get_height(barSpriteIndex);
	var _barX = _x;
	var _barY = _y;
	var _prop = 0;
	draw_sprite(barSpriteIndex, barImageIndex, _x, _y);
	_x += 190;
	_y -= 6;
	switch(barImageIndex)
	{
		case 0:
			// Health
			draw_set_color(hpColor);
			draw_text(_x,_y,string(hp));
			_prop = hp / statHealth;
			draw_rectangle(_barX,_barY,lerp(_barX,_barX+176,_prop),_barY+11,false);
			// Metal
			// Crystal
			break;
		case 1:
			// Health
			draw_set_color(hpColor);
			draw_text(_x,_y,string(hp));
			_prop = hp / statHealth;
			draw_rectangle(_barX,_barY,lerp(_barX,_barX+176,_prop),_barY+11,false);
			// Metal
			// Crystal
			draw_set_color(ctlColor);
			draw_text(_x,_y+26,string(rsc2));
			_prop = rsc2 / statResource2;
			draw_rectangle(_barX,_barY+25,lerp(_barX,_barX+176,_prop),_barY+36,false);
			break;
		case 2:
			// Health
			draw_set_color(hpColor);
			draw_text(_x,_y,string(hp));
			_prop = hp / statHealth;
			draw_rectangle(_barX,_barY,lerp(_barX,_barX+176,_prop),_barY+11,false);
			// Metal
			draw_set_color(mtlColor);
			draw_text(_x,_y+18,string(rsc1));
			_prop = rsc1 / statResource1;
			draw_rectangle(_barX,_barY+17,lerp(_barX,_barX+176,_prop),_barY+28,false);
			// Crystal
			break;
		case 3:
			// Health
			draw_set_color(hpColor);
			draw_text(_x,_y,string(hp));
			_prop = hp / statHealth;
			draw_rectangle(_barX,_barY,lerp(_barX,_barX+176,_prop),_barY+11,false);
			// Metal
			draw_set_color(mtlColor);
			draw_text(_x,_y+18,string(rsc1));
			_prop = rsc1 / statResource1;
			draw_rectangle(_barX,_barY+17,lerp(_barX,_barX+176,_prop),_barY+28,false);
			// Crystal
			draw_set_color(ctlColor);
			draw_text(_x,_y+36,string(rsc2));
			_prop = rsc2 / statResource2;
			draw_rectangle(_barX,_barY+34,lerp(_barX,_barX+176,_prop),_barY+45,false);
			break;
	}
	draw_set_alpha(1);
}
