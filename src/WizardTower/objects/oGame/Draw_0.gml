/// @description 

/*

// show the gridspace
draw_set_color(c_white)
draw_rectangle(0,0,room_width,room_height,true)
draw_set_alpha(0.2);

if(room != rStartMenu)
{
	for(var i=0;i<GRID_WIDTH;i++)
	{
	for(var j=0;j<GRID_HEIGHT;j++)
	{
		if(i & 1)
		{
			if(j & 1){draw_set_color(c_white)} else {draw_set_color(c_black)}
		} else {
			if(j mod 2 == 0){draw_set_color(c_white)} else {draw_set_color(c_black)}
		}
		draw_rectangle(i*TILE_SIZE, j*TILE_SIZE, i*TILE_SIZE + TILE_SIZE-1, j*TILE_SIZE + TILE_SIZE-1, true);
	}
	}
}
draw_set_color(c_white);
draw_set_alpha(1);
