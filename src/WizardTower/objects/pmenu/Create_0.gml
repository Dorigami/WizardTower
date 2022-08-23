/// @description Initialize
function TextBoxAdd(_x, _y, _cntr, _ind, _name, _spr, _text, _caption, _txtLim, _scr, _scrArgs){
	var _newControl = new TextBox()
	with _newControl
	{
		container = _cntr;
		index = _ind;
		name = _name;
		sprite = _spr;
		textLimit = _txtLim;
		text = _text;
		caption = _caption;
		activationScript = _scr;
		activationScriptArgs = _scrArgs;
		x = _x;
		y = _y;
	}
	_newControl.Init(); 
	ds_list_add(controlsList,_newControl); 
	ds_map_add(controlsMap,_name,_ind);
	return _newControl;
}
TextBox = function() constructor{
	container = noone;
	index = 0;
	name = "";
	sprite = undefined;
	image = 0;
	x = 0;
	y = 0;
	highlighted = false;
	highlightForced = false;
	activated = false;
	activationScript = -1;
	activationScriptArgs = -1;
	textLimit = 0;
	text = "";
	textCursor = true;
	textCursorTime = FRAME_RATE;
	textCursorTimer = -1;
	fontHeight = 0;
	caption = "";
	static Init = function(){
		if(!is_undefined(sprite))
		{
			draw_set_font(fTextSmall);
			fontHeight = string_height("L"); 
			width = sprite_get_width(sprite);
			height = sprite_get_height(sprite);
		}
	}
	static Update = function(){
		xTrue = x + container.x;
		yTrue = y + container.y;
		if(point_in_rectangle(mouse_x,mouse_y,xTrue,yTrue,xTrue+width,yTrue+height))
		{
			if(mouse_check_button_released(mb_any)) container.controlsFocus = index;
		}
		// allow for numerical inputs when focused
		if(container.controlsFocus == index)
		{
			//timer for the cursor blinking
			if(--textCursorTimer <= 0) 
			{
				textCursor = !textCursor
				textCursorTimer =  textCursorTime;
			}
			// backspace
			if(keyboard_check_pressed(vk_backspace))
			{
				if(text != "") text = string_copy(text,1,string_length(text)-1);
			}
			// numbers
			if(string_length(text) < textLimit)
			{
				for(var i=0; i<10; i++)
				{
					// check for normal number keys
					if(keyboard_check_pressed(48+i)){ text += string(i); break; }
					// check numpad number keys
					if(keyboard_check_pressed(96+i)){ text += string(i); break; }
				}
			}
			// enter key
			if(keyboard_check_pressed(vk_enter)) activated = true;
		} else { textCursor = false }
	
		if(activated)
		{
			activated = false;
			if(activationScript != -1) script_execute_array(activationScript, activationScriptArgs);
		}
	}
	static Draw = function(){
		var _x = xTrue-8;
		var _y = yTrue+0.5*height;
		var _wid = string_width(text);
		var _maxWid = string_width("HHHHHHH");
		var _hgt = 0.8*string_height(text);
		draw_set_color(c_black);
		image = index == container.controlsFocus ? 1 : 0;
		
		draw_sprite(sprite, image, xTrue, yTrue);
		//draw_set_color(c_white);
		//draw_rectangle(xTrue-1,yTrue-1,xTrue+_maxWid+1,yTrue+_hgt+1,false);
		//draw_set_color(c_black);
		//draw_rectangle(xTrue-1,yTrue-1,xTrue+_maxWid+1,yTrue+_hgt+1,true);
		draw_set_valign(fa_middle);
		draw_set_halign(fa_left);
		draw_text(_x+14,_y, text);
		if(caption != "") 
		{
			draw_set_valign(fa_middle);
			draw_set_halign(fa_right);
			draw_text(_x,_y,caption);
			draw_set_valign(fa_top);
			draw_set_halign(fa_left);
		}
		_x += _wid;
		_y -= 0.5*fontHeight;
		if(textCursor) draw_rectangle(_x+14,_y+2,_x+15,_y+fontHeight-3,false);
		draw_set_color(c_white);
	}
}
function ButtonAdd(_x, _y, _cntr, _ind, _name, _spr, _sprAlt, _scr, _scrArgs){
	var _newControl = new Button()
	with _newControl
	{
		container = _cntr;
		index = _ind;
		name = _name;
		sprite = _spr;
		spriteAlt = _sprAlt;
		activationScript = _scr;
		activationScriptArgs = _scrArgs;
		x = _x;
		y = _y;
	}
	_newControl.Init(); 
	ds_list_add(controlsList,_newControl); 
	ds_map_add(controlsMap,_name,_ind);
	return _newControl;
}
Button = function() constructor{
	container = noone;
	index = 0;
	name = "";
	sprite = undefined;
	spriteAlt = undefined;
	drawAlt = false;
	image = 0;
	width = 0;
	height = 0;
	x = 0;
	y = 0;
	xTrue = 0;
	yTrue = 0;
	enabled = true;
	highlighted = false;
	highlightForced = false;
	pressed = false;
	activated = false;
	activationScript = -1;
	activationScriptArgs = -1;
	static Init = function(){
		if(!is_undefined(sprite))
		{
			width = sprite_get_width(sprite);
			height = sprite_get_height(sprite);
		}
	}
	static Update = function(){
		xTrue = x + container.x;
		yTrue = y + container.y;
		if(enabled)
		{
			if(point_in_rectangle(mouse_x,mouse_y,xTrue,yTrue,xTrue+width,yTrue+height))
			{
				highlighted = true;
				pressed = mouse_check_button(mb_any) 
				if(mouse_check_button_released(mb_any)) 
				{
					container.controlsFocus = index;
					activated = true
				}
			} else {
				highlighted = false;
				pressed = false;
			}
			if(activated)
			{
				activated = false;
				if(activationScript != -1) script_execute_array(activationScript, activationScriptArgs);
			}
			// adjust the sprite
			image = 0;
			if(highlightForced) highlighted = true;
			if(highlighted) image = 1;
			if(pressed) image = 2;
		}
	}
	static Draw = function(){
		draw_set_color(c_black);
		if(instance_exists(container))&&(index == container.controlsFocus) draw_rectangle(xTrue,yTrue,xTrue+width,yTrue+height,true)
		draw_set_color(c_white);
		var _alpha = enabled ? min(1, container.image_alpha) : min(0.5, container.image_alpha); 
		draw_set_alpha(_alpha);
		if(drawAlt) && (!is_undefined(spriteAlt))
		{
			draw_sprite(spriteAlt, image, xTrue, yTrue)
		} else {
			draw_sprite(sprite, image, xTrue, yTrue);
		}
		draw_set_alpha(container.image_alpha);
	}
}
function LabelAdd(_x, _y, _cntr, _ind, _name, _spr, _text, _caption){
	var _newControl = new Label()
	with _newControl
	{
		container = _cntr;
		index = _ind;
		name = _name;
		sprite = _spr;
		text = _text;
		caption = _caption;
		x = _x;
		y = _y;
	}
	_newControl.Init(); 
	ds_list_add(controlsList,_newControl); 
	ds_map_add(controlsMap,_name,_ind);
	return _newControl;
}
Label = function() constructor{
	container = noone;
	index = -1;
	name = "";
	sprite = undefined;
	text = "";
	caption = "";
	image = 0;
	width = 0;
	height = 0;
	x = _x;
	y = _y;
	highlighted = false;
	highlightForced = false;
	pressed = false;
	activated = false;
	activationScript = -1;
	activationScriptArgs = -1;
	static Init = function(){
		if(!is_undefined(sprite))
		{
			width = sprite_get_width(sprite);
			height = sprite_get_height(sprite);
		} else {
			
		}
	}
	static Update = function(){
		xTrue = x + container.x;
		yTrue = y + container.y;
	}
	static Draw = function(){
		var _x = x+8;
		var _y = y+0.5*height;

		if(!is_undefined(sprite)) draw_sprite(sprite, image, x, y);
		draw_set_valign(fa_middle);
		draw_set_halign(fa_left);
		draw_text(_x,_y, text);
	}
}
controlsCount = 0;
controlsFocus = -1; 
controlsMap = ds_map_create();
controlsList = ds_list_create();

depth = BUTTONDEPTH;
image_speed = 0;
image_index = 0;

leftClick = false;
leftScript = -1;
leftArgs = -1;
rightClick = false;
rightScript = -1;
rightArgs = -1;
text = "";
baseColor = c_black;
highlightColor = c_yellow;
textColor = c_black;
textOffsetY = 0;
focus = false;
press = false;
gui = false;
enabled = true;

menuOpen = false;
if(ds_exists(global.iGame.menuStack, ds_type_stack)) ds_stack_push(global.iGame.menuStack, id);
