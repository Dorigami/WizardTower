/// @description 
draw_set_alpha(1);
draw_set_color(c_black);
draw_set_font(fDefault)
draw_set_halign(fa_center);




draw_set_valign(fa_middle);
for(var i=0; i<global.game_grid_width; i++){
for(var j=0; j<global.game_grid_height; j++){
	var _node = global.game_grid[# i, j];
draw_rectangle(
	global.game_grid_xorigin + i*GRID_SIZE, 
	global.game_grid_yorigin + j*GRID_SIZE,
	global.game_grid_xorigin + i*GRID_SIZE + GRID_SIZE - 1, 
	global.game_grid_yorigin + j*GRID_SIZE + GRID_SIZE - 1, 
	true
	);
}}
draw_set_alpha(1);
draw_set_color(c_red);
draw_rectangle(
	global.game_grid_xorigin, 
	global.game_grid_yorigin,
	global.game_grid_xorigin+GRID_SIZE*global.game_grid_width, 
	global.game_grid_yorigin+GRID_SIZE*global.game_grid_height, 
	true
	);
