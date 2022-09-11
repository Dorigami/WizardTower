/// @description 


if(towerObj == -1)
{
	draw_set_alpha(1);
	draw_set_color(c_black);
	draw_rectangle(rect[0],rect[1],rect[2],rect[3], true);
	draw_set_color(c_white);
} else {
	draw_set_alpha(0.1);
	draw_set_color(c_black);
	draw_rectangle(rect[0],rect[1],rect[2],rect[3], false);
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_alpha(0.5);
	draw_sprite(sprite, 0, rect[0], rect[1]);
	draw_set_alpha(1);
}
