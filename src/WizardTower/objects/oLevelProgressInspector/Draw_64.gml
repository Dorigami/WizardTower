/// @description 

// draw left part
draw_sprite(sprite_index,0,x-middle_length-6,y);
// draw middle part
draw_sprite_part_ext(sprite_index,1,33,0,1,sprite_height,x,y,-middle_length,1,image_blend,image_alpha);
// draw right part
draw_sprite(sprite_index,2,x,y);

// draw the bbox
draw_set_color(c_lime);
draw_set_alpha(0.5);
draw_rectangle(progress_bbox[0],progress_bbox[1],progress_bbox[2],progress_bbox[3],false);
draw_set_alpha(1);

// draw the target data
if(draw_script != -1){ script_execute(draw_script) }
