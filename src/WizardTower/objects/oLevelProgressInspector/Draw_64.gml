/// @description 

// draw left part
draw_sprite(sprite_index,0,x-middle_length-6,y);
// draw middle part
draw_sprite_part_ext(sprite_index,1,33,0,1,sprite_height,x,y,-middle_length,1,image_blend,image_alpha);
// draw right part
draw_sprite(sprite_index,2,x,y);

// draw the target data
if(draw_script != -1){ script_execute(draw_script) }
