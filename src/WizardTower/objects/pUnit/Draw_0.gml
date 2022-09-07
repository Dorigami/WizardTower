/// @description

if(shadowEnabled) draw_sprite_ext(sShadow,0,floor(x),floor(y),shadowScale,shadowScale,0,c_white,1);

if(flash != 0)
{   // set shader
	shader_set(flashShader); uFlash = shader_get_uniform(flashShader, "flash"); shader_set_uniform_f(uFlash, flash);
	// draw flashing entity
	draw_sprite_ext( sprite_index,image_index,floor(x),floor(y-z),image_xscale,image_yscale,image_angle,image_blend,image_alpha);
	shader_reset();
} else {
	// draw entity normally
	draw_sprite_ext( sprite_index,image_index,floor(x),floor(y-z),image_xscale,image_yscale,image_angle,image_blend,image_alpha);
}
// draw a health bar
if(hp < hpMax)
{
	draw_healthbar(hpRect[0],hpRect[1],hpRect[2],hpRect[3],100*(hp/hpMax),c_black,c_green,c_green,0,true,true);
}

/*
 
original draw code, with unit selection 
if(shadowEnabled) draw_sprite_ext(sShadow,0,floor(x),floor(y),shadowScale,shadowScale,0,c_white,1);
if(selected){
	if(ds_exists(path,ds_type_list))
	{
		if(ds_list_size(path) > 1)
		{
			for(var i=1;i<ds_list_size(path);i++)
			{
				var _node0 = path[| i-1];
				var _node1 = path[| i];
				draw_set_color(c_yellow);
				draw_set_alpha(0.5);
				draw_line(_node0.center[1], _node0.center[2],_node1.center[1], _node1.center[2]);
			}
		}
	}
	// outline the entity
	shader_set(shOutline);
	shader_set_uniform_f(upixelW, texelW);
	shader_set_uniform_f(upixelH, texelH);
	draw_sprite_ext(sprite_index,image_index,x,y-z,1,1,0,c_white,image_alpha);
	shader_reset();
	// show flash on entity
	if(flash != 0)
	{   // set shader
		shader_set(flashShader); uFlash = shader_get_uniform(flashShader, "flash"); shader_set_uniform_f(uFlash, flash);
		// draw flashing entity
		draw_sprite_ext( sprite_index,image_index,floor(x),floor(y-z),image_xscale,image_yscale,image_angle,image_blend,image_alpha);
		shader_reset();
	}
	draw_set_color(c_white);
	if(destination != -1) draw_circle(destination[1], destination[2], 3, false);
} else {
	if(flash != 0)
	{   // set shader
		shader_set(flashShader); uFlash = shader_get_uniform(flashShader, "flash"); shader_set_uniform_f(uFlash, flash);
		// draw flashing entity
		draw_sprite_ext( sprite_index,image_index,floor(x),floor(y-z),image_xscale,image_yscale,image_angle,image_blend,image_alpha);
		shader_reset();
	} else {
		// draw entity normally
		draw_sprite_ext( sprite_index,image_index,floor(x),floor(y-z),image_xscale,image_yscale,image_angle,image_blend,image_alpha);
	}
}

//--/////////////////////////////////////////////// 
////// show context

var _innerLen = 20;
var _outerLen = 60;
var _diffLen = _outerLen - _innerLen;
draw_set_alpha(0.25);
for(var i=0; i<CS_RESOLUTION; i++)
{
	var _dir = i*(360 div CS_RESOLUTION);
	var _x1 = x + lengthdir_x(_innerLen, _dir);
	var _y1 = y + lengthdir_y(_innerLen, _dir);
	// interest data
	var _x2 = _x1 + lengthdir_x(_diffLen*interestMap[i], _dir);
	var _y2 = _y1 + lengthdir_y(_diffLen*interestMap[i], _dir);
	var _x3 = _x1 + lengthdir_x(_diffLen*1.4, _dir);
	var _y3 = _y1 + lengthdir_y(_diffLen*1.4, _dir);
	draw_set_color(c_green);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_line_width(_x1, _y1, _x2, _y2, 3);	
	//draw_text(_x3, _y3, string(interestMap[i]));
	// danger data
	_x2 = _x1 + lengthdir_x(_diffLen*dangerMap[i], _dir);
	_y2 = _y1 + lengthdir_y(_diffLen*dangerMap[i], _dir);
	_x3 = _x1 + lengthdir_x(_diffLen*1.4, _dir);
	_y3 = _y1 + lengthdir_y(_diffLen*1.4, _dir);
	draw_set_color(c_red);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_line_width(_x1, _y1, _x2, _y2, 3);	
	//draw_text(_x3, _y3+15, string(dangerMap[i]));
}
draw_set_color(c_white);
draw_circle(x,y,_innerLen,true);
draw_circle(x,y,_outerLen,true);

//--///////////////////////////////////////////////

//show_debug_message(string(shader_current()));
//// reset shader
//if(shader_current() != -1) 
//show_debug_message("! 5 !");
//draw_text(x+20,y-40,"alarm[0] = " + string(alarm[0]) 
//			   + "\nstate: " + script_get_name(stateScript[state])
//			   + "\ndestination: " + string(destination)
//			   + "\ntarget: " + string(target)
//);