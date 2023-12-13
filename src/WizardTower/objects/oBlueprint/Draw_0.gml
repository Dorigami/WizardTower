/// @description 

var _main_alpha = 0.7;
var _color_alpha = 0.2;

draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, c_white, _main_alpha);
draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, cantplace ? c_red : c_green, _color_alpha);

