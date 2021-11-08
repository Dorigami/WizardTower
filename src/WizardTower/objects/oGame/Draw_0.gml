/// @description 
draw_set_color(c_white)
draw_rectangle(0,0,room_width,room_height,true)

if(room != rStartMenu)
{
	// draw the grid cells
	var _width = ds_grid_width(global.gridSpace);
	var _height = ds_grid_height(global.gridSpace);
	for(var i=0;i<_width;i++)
	{
	for(var j=0;j<_height;j++)
	{
		var _node = global.gridSpace[# i, j];
		if(_node.enabled)
		{
			// show node data
			draw_set_font(fText);
			draw_set_valign(fa_middle);
			draw_set_halign(fa_center);
			draw_text(_node.center[1], _node.center[2], string(_node.timer));
		}
	}
	}
	draw_set_alpha(1);
	draw_set_color(c_white);
}

