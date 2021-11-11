/// @description 

if(selected){
	// outline the unit
	shader_set(shOutline);
	shader_set_uniform_f(upixelW, texelW);
	shader_set_uniform_f(upixelH, texelH);
	draw_self();
	shader_reset();
	//if(path_exists(path_) && path_position < 1) draw_path(path_,x,y,true);
} else {
	draw_self();
}

draw_text(x+10,y+10,string(selected)+ "\n arrived = "+string(arrived));
