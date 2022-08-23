/// @description 
draw_set_alpha(1);
draw_set_font(fTextSmall)
draw_set_color(c_dkgray)
draw_rectangle(x,y,x+width,y-tabHeight,false);
draw_set_color(c_gray);
draw_rectangle(x,y,x+width,y+width,false);
draw_set_color(c_white);


// Inherit the parent event
event_inherited();

