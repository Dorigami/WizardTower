/// @description 

if(global.mouse_focus == id)
{
	// draw outline around the entity
	shader_set(shOutline);
	shader_set_uniform_f(upixelW, texelW);
	shader_set_uniform_f(upixelH, texelH);
	draw_sprite_ext(sprite_index,image_index,x,y,image_xscale,image_yscale,0,c_white,image_alpha);
	shader_reset();
}

// draw the entity
draw_self();

if(!is_undefined(ai))
{
	var _size = ds_list_size(ai.commands);
	// show goal points for each command
	if(_size > 0) && (selected){	
	for(var i=0; i<_size; i++){
		var _cmd = ai.commands[| i];
		var _x1 = i==0 ? x : ai.commands[| i-1].x;
		var _y1 = i==0 ? y : ai.commands[| i-1].y;
		var _x2 = _cmd.x;
		var _y2 = _cmd.y;

		draw_set_color(_cmd.type == "move" ? c_blue : c_red);

		draw_circle(_cmd.x, _cmd.y, 4, false);
		draw_line(_x1, _y1, _x2, _y2);

		draw_set_color(c_white);
	}}
}

var _prog = 0;
if(!is_undefined(structure)) || (!is_undefined(blueprint))
{
	var _stt = undefined;
	if(!is_undefined(structure)) _stt = structure;
	if(!is_undefined(blueprint)) 
	{
		_stt = blueprint;
	}
	if(_stt.build_timer_set_point > 0)
	{
		_prog = 100*(_stt.build_timer / _stt.build_timer_set_point);
		draw_healthbar(buildtimer_bbox[0],buildtimer_bbox[1],buildtimer_bbox[2],buildtimer_bbox[3],_prog,c_black,c_gray,c_gray,0,true,false);
	}
}

if(!is_undefined(fighter))
{
	draw_text(x+10,y+10,"en: " + string(ds_list_size(fighter.enemies_in_range)));
	if(fighter.basic_cooldown_timer > 0)
	{
		_prog = fighter.basic_cooldown_timer; 
		draw_healthbar(basicattackbar_bbox[0],basicattackbar_bbox[1],basicattackbar_bbox[2],basicattackbar_bbox[3],_prog,c_black,c_gray,c_gray,0,true,false);
	}
	if(fighter.active_cooldown_timer > 0)
	{
		_prog = fighter.active_cooldown_timer; 
		draw_healthbar(activeattackbar_bbox[0],activeattackbar_bbox[1],activeattackbar_bbox[2],activeattackbar_bbox[3],_prog,c_black,c_gray,c_gray,0,true,false);
	}
	if(fighter.hp < fighter.hp_max)
	{
		_prog = 100*(fighter.hp / fighter.hp_max);
		draw_healthbar(healthbar_bbox[0],healthbar_bbox[1],healthbar_bbox[2],healthbar_bbox[3],_prog,c_black,c_green,c_green,0,true,false);
	}
}


