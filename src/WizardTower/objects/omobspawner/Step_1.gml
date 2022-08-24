/// @description 

// allow dragging
if(tabDrag)
{
	x = clamp(mouse_x + mouseOffsetX, 0, GRID_WIDTH*TILE_SIZE - width);
	y = clamp(mouse_y + mouseOffsetY, tabHeight, GRID_HEIGHT*TILE_SIZE - height);
} else {
	x = clamp(x, 0, GRID_WIDTH*TILE_SIZE - width);
	y = clamp(y, tabHeight, GRID_HEIGHT*TILE_SIZE - height);
}
