/// @description 

if(cantplace)
{
	draw_set_alpha(0.2);
	draw_set_color(c_red);
}else{
	draw_set_alpha(0.2);
	draw_set_color(c_green);
} 

draw_rectangle(rect[0],rect[1],rect[2],rect[3], false);
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_alpha(0.5);
draw_sprite(sprite_index, 0, x, y);
draw_set_alpha(1);

draw_circle(x,y,4,false);