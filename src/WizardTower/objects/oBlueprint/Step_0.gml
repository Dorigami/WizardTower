/// @description 


if(global.iEngine.blueprint_instance != id) exit;

if(lock_to_grid)
{
	var _xx = (mouse_x - global.game_grid_xorigin) div GRID_SIZE;
	var _yy = (mouse_y - global.game_grid_yorigin) div GRID_SIZE;
	// move blueprint with the mouse, but lock it to grid cells
	if(point_in_rectangle(_xx, _yy, 0, 0, global.game_grid_width-1, global.game_grid_height-1)) && ((xx != _xx) || (yy != _yy))
	{
		var _cw = size[0] div 2;      // center width
		var _ch = size[1] div 2;      // center height 

		xx = _xx;
		yy = _yy;
		x = (mouse_x div GRID_SIZE)*GRID_SIZE+HALF_GRID;
		y = (mouse_y div GRID_SIZE)*GRID_SIZE+HALF_GRID;

		rect = [
			global.game_grid_xorigin + (xx-_cw)*GRID_SIZE,
			global.game_grid_yorigin + (yy-_ch)*GRID_SIZE,
			global.game_grid_xorigin + (xx-_cw+size[0])*GRID_SIZE - 1,
			global.game_grid_yorigin + (yy-_ch+size[1])*GRID_SIZE - 1
		];

		cantplace = CheckPlacement();
	}
} else {
	if(point_in_rectangle(mouse_x, mouse_y, 0,0,GRID_SIZE*global.game_grid_width, GRID_SIZE*global.game_grid_height))
	{
		x = mouse_x;
		y = mouse_y;
	    xx = mouse_x div GRID_SIZE;
	    yy = mouse_y div GRID_SIZE;
	}
	if(--position_update_timer <= 0)
	{
		var _cw = size[0] div 2;      // center width
		var _ch = size[1] div 2;      // center height 

		rect = [
			(xx-_cw)*GRID_SIZE,
			(yy-_ch)*GRID_SIZE,
			(xx-_cw+size[0])*GRID_SIZE - 1,
			(yy-_ch+size[1])*GRID_SIZE - 1
		];

		position_update_timer = position_update_time;
		cantplace = CheckPlacement();
	}
}