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

if(ds_exists(path,ds_type_list))
{
	for(var i=0;i<ds_list_size(path);i++)
	{
		var _node = path[| i];
		draw_set_color(c_yellow);
		draw_set_alpha(0.5);
		draw_circle(_node.center[1], _node.center[2],4,false);
	}
}