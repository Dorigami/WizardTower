/// @description Highlight and Show Range if Selected
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(fDefault)
draw_set_halign(fa_center);

if(room == rShaderTest)
{
	if(script_exists(shader_draw_script)) script_execute(shader_draw_script);
}
