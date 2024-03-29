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
//draw_self();
if(z > 0) draw_sprite_ext(sShadow,0,x,y,shadow_scale,shadow_scale,0,c_white,1);

draw_sprite_ext(sprite_index,image_number,x,y-z,image_xscale,image_yscale,image_angle,image_blend,image_alpha)

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
	// display attack range
	if(selected)
	{
		if(array_length(nodes_in_range) > 0)
		{
			var _hex = [2, 0, 0]; 
			var _pos = [2, 0, 0];
			var _index = 0;
			var _container = -1;
			draw_set_alpha(0.1);
			draw_set_alpha(c_white);
			for(var i=0;i<array_length(nodes_in_range);i++)
			{
				_hex = nodes_in_range[i];
				with(global.i_hex_grid)
				{
					_index = hex_get_index(_hex);
					_pos = hex_to_pixel(other.nodes_in_range[i], true);
					if(is_undefined(_index)) { show_debug_message("hex index in range doesn't exist: hex={0} index={1}", _hex, _index); continue; }
					//show_debug_message("he data collected: index={0}, position={1}, container={2}", _index, _pos, hexarr_containers);
					_container = hexarr_containers[_index];
					
				}
				if(ds_exists(_container, ds_type_list))
				{
					draw_set_alpha(0.2);
					draw_sprite(sHexRangeIndicator, ds_list_size(_container) > 0, _pos[1], _pos[2]);
				}
			}
		}
	}
}

var _prog = 0;
if(!is_undefined(structure)) || (!is_undefined(blueprint))
{
	var _stt = undefined;
	if(!is_undefined(structure)) _stt = structure;
	if(!is_undefined(blueprint)) _stt = blueprint;

	if(_stt.build_timer_set_point > 0)
	{
		_prog = 100*(_stt.build_timer / _stt.build_timer_set_point);
		draw_healthbar(buildtimer_bbox[0],buildtimer_bbox[1],buildtimer_bbox[2],buildtimer_bbox[3],_prog,c_black,c_gray,c_gray,0,true,false);
	}
}

if(!is_undefined(fighter))
{
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


