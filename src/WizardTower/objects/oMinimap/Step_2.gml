/// @description 

with(global.iCamera)
{
	other.xx = (x-global.game_grid_xorigin) div GRID_SIZE;
	other.yy = (y-global.game_grid_yorigin) div GRID_SIZE;
}

zoom = global.iEngine.view_zoom;

view_bbox.x1 = ox + xx - zoom*tilehalfwidth+1;
view_bbox.y1 = oy + yy - zoom*tilehalfheight+1;
view_bbox.x2 = ox + xx + zoom*tilehalfwidth-1;
view_bbox.y2 = oy + yy + zoom*tilehalfheight-1;
