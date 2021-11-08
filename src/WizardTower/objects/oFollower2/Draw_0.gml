/// @description 

draw_set_alpha(1);
draw_set_color(c_white);
draw_self();

if(showContext)
{
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
	var _innerLen = 20;
	var _outerLen = 60;
	var _diffLen = _outerLen - _innerLen;
	draw_set_alpha(0.25);
	for(var i=0; i<12; i++)
	{
		var _dir = i*30;
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
}
draw_set_alpha(1);
draw_set_color(c_white);

//draw_text(mouse_x,mouse_y,"pos: [" + string(position_[1]) + "  " + string(position_[2]) + "]" + "\n" + "vel: [" + string(velocity_[1]) + "  " + string(velocity_[2]) + "]");
