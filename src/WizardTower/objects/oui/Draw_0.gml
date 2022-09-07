/// @description 

// initialize
draw_set_alpha(image_alpha);
draw_set_font(fText);

// Inherit the parent event
//-0-// the ui has a modified draw event (below)
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
	draw_sprite_ext(sUIinfo,
	                0,
				    x,
					y+yMenu,
					image_xscale,
					3,
					0,
					image_blend,
					image_alpha
					);
	// interactable areas
	draw_set_alpha(min(image_alpha,0.4));
	draw_set_color(c_yellow);
	draw_rectangle(rectPurchase[0],rectPurchase[1],rectPurchase[2],rectPurchase[3],false);
	draw_set_color(c_blue);
	draw_rectangle(rectUpgrade[0],rectUpgrade[1],rectUpgrade[2],rectUpgrade[3],false);
	draw_set_color(c_green);
	draw_rectangle(rectInfo[0],rectInfo[1],rectInfo[2],rectInfo[3],false);
	draw_set_color(c_aqua);
	draw_rectangle(rectStart[0],rectStart[1],rectStart[2],rectStart[3],false);
	draw_set_alpha(1);
}
if(controlsCount > 0)
{
	for(var i=0; i<controlsCount; i++)
	{
		var _ctrl = controlsList[| i];
		_ctrl.Draw();
	}
}

//-0-// the ui has a modified draw event (above)

draw_set_alpha(image_alpha);
var _x = x + 20;
var _y = y + 30;
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fTextSmall);


// health bar
var _hp = string(global.iGame.playerHealth);
var _money = string(global.iGame.playerMoney);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(_x,_y,"HEALTH: " + _hp + 
                      "\nMONEY: " + _money  
					  );

// timeline bar
with(global.iGame)
{
	if(!is_undefined(stageData))
	{
		if(timeline_index != -1) && (is_array(timelineMarkers))
		{
			var _x = other.viewWidthHalf-60;
			var _xx = 0;
			var _y = 20;
			var _w = 400;
			var _h = 6;
			var _size = array_length(timelineMarkers);
			var _percent = 0;
			// draw the timeline representation
			// main line
			draw_set_color(c_white);
			draw_rectangle(_x,_y,_x+_w,_y+_h,false);
			// notches
			for(var i=0;i<_size;i++)
			{
				_percent = timelineMarkers[i] / timelineMarkers[_size-1];
				_xx = _x + (_w*_percent);
				draw_rectangle(_xx-3,_y-4,_xx+3,_y+_h+4,false);
			}
			// current position in timeline
			_percent = timeline_position / timelineMarkers[_size-1];
			_xx = _x + (_w*_percent);
			draw_set_color(c_blue);
			draw_rectangle(_xx-3,_y-4,_xx+3,_y+_h+4,false);
		}
	}
}

draw_set_alpha(1);

if(global.gamePaused)
{
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	_x = x + 0.5*viewWidthHalf;
	_y = y + 0.3*viewHeightHalf;
	draw_text(_x,_y,"GAME PAUSED");
	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
}