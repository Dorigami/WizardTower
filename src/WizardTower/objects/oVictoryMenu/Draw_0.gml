/// @description 

// draw the backdrop
draw_set_alpha(backdrop_alpha);
draw_set_color(c_black);
draw_rectangle(backdrop_bbox[0],backdrop_bbox[1],backdrop_bbox[2],backdrop_bbox[3],false);

// Inherit the parent event
event_inherited();

