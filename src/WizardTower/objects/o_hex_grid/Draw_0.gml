/// @description 

var _halfgrid_width = hexgrid_width_pixels div 2;
var _halfgrid_height = hexgrid_height_pixels div 2;

draw_set_alpha(1);
draw_set_color(c_teal);
draw_rectangle(x-_halfgrid_width, y-_halfgrid_height, x+_halfgrid_width, y+_halfgrid_height, true);

for(var i=0;i<ds_list_size(hexgrid_enabled_list);i++)
{
	var ind = hexgrid_enabled_list[| i];
	var _x = hexarr_positions[ind][1];
	var _y = hexarr_positions[ind][2];
	draw_sprite(sWireHexSingle,0,_x,_y);
}







