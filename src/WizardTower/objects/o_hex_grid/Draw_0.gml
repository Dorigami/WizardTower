/// @description 
draw_set_color(c_white);
draw_rectangle(x-4,y-4,x+4,y+4,false);

var _halfgrid_width = hexgrid_width_pixels div 2;
var _halfgrid_height = hexgrid_height_pixels div 2;

var bbox = global.iCamera.cam_bounds;

draw_set_alpha(1);
draw_set_color(c_teal);
draw_rectangle(bbox[0], bbox[1], bbox[2], bbox[3], true);

for(var i=0;i<ds_list_size(hexgrid_enabled_list);i++)
{
	var ind = hexgrid_enabled_list[| i];
	var _x = hexarr_positions[ind][1];
	var _y = hexarr_positions[ind][2];
	draw_sprite(sWireHexSingle,0,_x,_y);
	if(hexarr_is_goal[ind])
	{
		draw_set_color(c_yellow);
		draw_circle(_x,_y,4,false);
	}
	if(hexarr_is_spawn[ind])
	{
		draw_set_color(c_blue);
		draw_circle(_x,_y,4,false);
	}
}







