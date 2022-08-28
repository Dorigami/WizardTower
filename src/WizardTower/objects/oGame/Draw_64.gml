/// @description view data

/*
 
// show all unit data
var _str = "";
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);
with(pUnit)
{
	_str += "\n["+string(x)+" "+string(y)+"] " + string(pathPos) + "  target node: " + string(pathNode) + "  dir: " + string(direction) + "  vel: " + string(velocity);
}
draw_text(20,20,_str);
// show mouse position
draw_set_color(c_black);
draw_text(mouse_x+1,mouse_y+10, string(mouse_x) + " , " + string(mouse_y));
draw_text(mouse_x-1,mouse_y+10, string(mouse_x) + " , " + string(mouse_y));
draw_text(mouse_x,mouse_y+11, string(mouse_x) + " , " + string(mouse_y));
draw_text(mouse_x,mouse_y+9, string(mouse_x) + " , " + string(mouse_y));
draw_set_color(c_white);
draw_text(mouse_x,mouse_y+10, string(mouse_x) + " , " + string(mouse_y));
