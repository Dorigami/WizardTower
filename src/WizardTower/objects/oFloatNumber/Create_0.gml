/// @description 

alpha = 1;
init = false;

depth = UPPERTEXDEPTH-1;

function Draw(){
	if(!is_undefined(value))
	{
		draw_set_alpha(alpha);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_font(fFloatText);
		//outline
		draw_set_color(c_black);
		draw_text(x+1,y,string(value));
		draw_text(x-1,y,string(value));
		draw_text(x,y+1,string(value));
		draw_text(x,y-1,string(value));
		//fill
		draw_set_color(c_white);
		draw_text(x,y,string(value));

		draw_set_alpha(1);
	}
}
