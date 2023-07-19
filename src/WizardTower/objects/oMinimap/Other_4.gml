/// @description 

tilehalfwidth = (camera_get_view_width(view_camera[0])*0.25) div GRID_SIZE;
tilehalfheight = (camera_get_view_height(view_camera[0])*0.25) div GRID_SIZE;

ox = display_get_gui_width() - global.game_grid_width - 20;
oy = 4;// display_get_gui_height() - global.game_grid_height;

// show_message("height in tiles = "+string(2*tilehalfheight))
