/// @description 

var _width = display_get_gui_width();
var _height = display_get_gui_height();

// set text properties
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// draw the title to the screen
draw_set_alpha(titleAlpha);
draw_set_font(fText);
draw_set_color(c_white);
draw_text(0.5*_width,0.25*_height,title)

/*

// draw each option to the screen
draw_set_alpha(optionAlpha)
draw_set_font(fDefault);
for(var i=0; i<array_length(options); i++)
{
	var _btn = options[i];
	// draw the button sprite
	if(_btn.sprite != -1)
	{
		draw_set_color(c_white);
		draw_sprite(_btn.sprite,_btn.image,_btn.x,_btn.y);
	}
	// draw the button text
	draw_set_color(_btn.textColor);
	if(_btn.focus) draw_set_color(c_yellow) else draw_set_color(c_white);
	draw_text(0.5*_width,0.5*_height+(i*40),options[i])
}
draw_set_alpha(1);

/*

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(mouse_x+10,mouse_y+40,string(titleAlpha) 
                         +"\n"+ string(optionAlpha)
						 +"\n"+ string(alarm[0])
						 +"\n"+ string(alarm[1])
						 +"\nintro?: " + (intro ? "YES" : "NO") 
						 );