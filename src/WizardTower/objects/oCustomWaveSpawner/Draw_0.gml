/// @description 

draw_set_color(c_blue);	
draw_set_font(fCustomWaveSpawner);
draw_rectangle(tab_bbox[0],tab_bbox[1],tab_bbox[2],tab_bbox[3],false);
draw_set_color(c_white);
draw_set_alpha(0.4);
draw_rectangle(x,y,x+tab_wdt,y+array_length(widget_names)*hgt,false);
draw_set_color(c_black);
draw_set_alpha(1);
// Inherit the parent event
event_inherited();



