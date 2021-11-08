/// @description 

#macro EAST 0
#macro NORTH 1
#macro WEST 2
#macro SOUTH 3
#macro GRID_WIDTH 16
#macro GRID_HEIGHT 16
#macro CELL_SIZE 60

global.gridSpace = ds_grid_create(GRID_WIDTH, GRID_HEIGHT);
global.speed = 3;