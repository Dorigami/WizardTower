/// @description 

ox = display_get_gui_width() div 2;
oy = display_get_gui_height() div 2;

main_size = 10;
mouse_size = 10;
component_size = 10;

main_color = c_red;
mouse_color = c_black;
component_color = c_lime;

main_vect = speed_dir_to_vect2(80, irandom(359));
mouse_vect = speed_dir_to_vect2(80, irandom(359));
component_vect = speed_dir_to_vect2(80, irandom(359));

collision_radius = sprite_get_width(sprite_index) div 2;

xxx = global.game_grid_xorigin + (global.game_grid_width*GRID_SIZE);
yyy = global.game_grid_yorigin + (global.game_grid_height*GRID_SIZE);
x = xxx;
y = yyy;
position = vect2(x,y);

moveable = true;


