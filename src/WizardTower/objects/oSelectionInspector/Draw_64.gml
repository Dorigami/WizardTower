/// @description 

draw_set_color(c_lime);
draw_set_alpha(0.5);
draw_rectangle(inspectior_bbox[0],inspectior_bbox[1],inspectior_bbox[2],inspectior_bbox[3],false);

if(inspect_draw_script != -1) script_execute(inspect_draw_script);








