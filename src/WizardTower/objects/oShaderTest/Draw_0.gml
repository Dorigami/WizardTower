/// @description Highlight and Show Range if Selected
draw_set_font(fDefault);
draw_text(mouse_x, mouse_y+20, "["+string(mouse_x)+", "+string(mouse_y)+"]")

draw_set_color(c_white);
draw_rectangle(0,0,room_width,room_height,true)

if(room == rmShader)
{
	if(script_exists(shader_draw_script)) script_execute(shader_draw_script);
}