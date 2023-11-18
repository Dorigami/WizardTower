/// @description Initialize Variables

function ShadeInitializeDisplay(_asp){
	// static resolution
	show_debug_message("Initialize Display: asp ratio = {0}", _asp);
	aspect_ratio_ = _asp;
	idealWidth = CANVAS_W;
	idealHeight = round(idealWidth / _asp);
	

	//check for odd numbers
	if(idealWidth & 1) idealWidth++;
	if(idealHeight & 1) idealHeight++;

	//do the zoom
	zoom = 1; // 1, 2, or 3
	zoomMax = floor(display_get_width() / idealWidth);
	zoom = min(zoom, zoomMax);
	view_zoom = 1;
	
	// enable & set views of each room
	for(var i=0; i<=100; i++)
	{
		if(!room_exists(i)) break;
		show_debug_message(room_get_name(i)+" has been initialized")
		if(i == 30){show_message("update display initialize, there are too many rooms")}
		room_set_view_enabled(i, true);
		room_set_viewport(i,0,true,0,0,idealWidth, idealHeight);
		//room_set_camera(i,0,view_camera[0])
	}	
	surface_resize(application_surface, idealWidth, idealHeight);
	display_set_gui_size(idealWidth, idealHeight);
	window_set_size(idealWidth*zoom, idealHeight*zoom);
}

function my_custom_shader_draw(){
	shader_set(sh_custom);
	shader_set_uniform_f(umouseX, texelW*mouse_x);
	shader_set_uniform_f(umouseY, texelH*mouse_y);
	shader_set_uniform_f(uresW, texelW*CANVAS_W);
	shader_set_uniform_f(uresH, texelH*CANVAS_H);
	shader_set_uniform_f(uTime, current_time*0.001);
	draw_self();
	shader_reset();
}

function tutorial_shader_draw(){
	shader_set(sh_tutorial);
	shader_set_uniform_f(uresW, texelW*CANVAS_W);
	shader_set_uniform_f(uresH, texelH*CANVAS_H);
	shader_set_uniform_f(uTime, current_time*0.001);
	draw_self();
	shader_reset();
}

function tree_tutorial_shader_draw(){
	shader_set(sh_tree_tutorial);
	shader_set_uniform_f(umouseX, texelW*mouse_x);
	shader_set_uniform_f(umouseY, texelH*mouse_y);
	shader_set_uniform_f(uresW, texelW*CANVAS_W);
	shader_set_uniform_f(uresH, texelH*CANVAS_H);
	shader_set_uniform_f(uTime, current_time*0.001);
	draw_self();
	shader_reset();
}


room_set_height(rShaderTest, CANVAS_H);
room_set_width(rShaderTest, CANVAS_W);
room_set_viewport(rShaderTest,0,true,0,0,CANVAS_W, CANVAS_H);

ShadeInitializeDisplay(1);

shader = sh_custom;
switch(shader)
{
	case sh_tree_tutorial:
		shader_draw_script = tree_tutorial_shader_draw; break;
	case sh_tutorial:
		shader_draw_script = tutorial_shader_draw; break;
	case sh_custom:
		shader_draw_script = my_custom_shader_draw; break;
	default:
		shader_draw_script = -1; break;
}
umouseX = shader_get_uniform(shader, "mouseX");
umouseY = shader_get_uniform(shader, "mouseY");
uTime = shader_get_uniform(shader, "iTime");
uresW = shader_get_uniform(shader, "resW");
uresH = shader_get_uniform(shader, "resH");
texelW = texture_get_texel_width(sprite_get_texture(sShaderCanvas,0));
texelH = texture_get_texel_height(sprite_get_texture(sShaderCanvas,0));

with(pButton) instance_destroy();
with(oHUD) instance_destroy();
with(oCamera) instance_destroy();
