/// @description show the window

//--// DRAW THE WINDOW
	nine_slice_box_smooth(bg_sprite,b_left,b_top,b_right,b_bottom);

//--// DRAW EACH SECTION OF TEXT
	draw_set_alpha(alpha_);
	draw_set_color(c_black);
	// TITLE SECTION
	draw_set_font(fDefault);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text(b_left+0.5*width_,b_top+0.6*title_height_,title_);
	// DESCRIPTION SECTION
	draw_set_font(fDefault);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_text_ext(b_left+10,b_top+title_height_,description_,3+string_height("I"),width_-20);
	// VALUES SECTION
	if(!is_undefined(values_))
	{
		
		for(var i=0; i<array_length(values_); i++)
		{
			draw_text(b_left+10,b_top+title_height_+description_height_+5+(i*(2+string_height("I"))),values_[$ values_names[i]]);
		}
	}
	
	//reset text values
	draw_set_font(fDefault);
	draw_set_color(c_white);
	draw_set_alpha(1);
