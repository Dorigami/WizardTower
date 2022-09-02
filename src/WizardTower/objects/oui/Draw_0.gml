/// @description 

draw_set_alpha(image_alpha);
draw_set_font(fText);
// Inherit the parent event
event_inherited();

draw_set_alpha(image_alpha);
var _x = x + 20;
var _y = y + 20;
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

// timeline bar
with(global.iGame)
{
	if(timeline_index != -1) && (timelineMarkers != undefined)
	{
		var _x = 0.5*_width-200;
		var _xx = 0;
		var _y = 10;
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