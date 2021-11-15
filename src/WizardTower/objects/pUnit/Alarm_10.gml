/// @description update path

if(state == STATE.FREE) && (!arrived) && (destination != -1)
{
	//var _node = global.gridSpace[# position[1] div CELL_SIZE, position[2] div CELL_SIZE];
	var _x = clamp(destination[1], 0, GRID_WIDTH*CELL_SIZE-1);
	var _y = clamp(destination[2], 0, GRID_HEIGHT*CELL_SIZE-1);
	PathRequest([id], position, vect2(_x,_y));
} else {
	path = -1; 
}

