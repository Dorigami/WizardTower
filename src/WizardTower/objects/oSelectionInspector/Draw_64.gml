/// @description 

draw_set_color(c_lime);
draw_set_alpha(0.5);
draw_rectangle(inspection_bbox[0],inspection_bbox[1],inspection_bbox[2],inspection_bbox[3],false);

if(inspect_draw_script != -1) script_execute(inspect_draw_script);








