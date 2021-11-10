/// @description 

depth = MENUDEPTH;

// title fade in variables
title = "WIZARD TOWER"
intro = true;
titleAlpha = 0;
optionAlpha = 0;
alarm[0] = FRAME_RATE*1;
alarm[1] = FRAME_RATE*2;

var _width = display_get_gui_width();
var _height = display_get_gui_height();
//var _width = room_width;
//var _height = room_height;
optionFocus = 0;
var _sprite = sBtn40x32;
options[0] = CreateButton(oButtonGeneric,_sprite,0.5*_width-(0.5*sprite_get_width(_sprite)),0.5*_height,"PLAY",true,
					      GoToLevel,[rTest],
						  GoToLevel,[rTest]);
options[1] = CreateButton(oButtonGeneric,_sprite,0.5*_width-(0.5*sprite_get_width(_sprite)),0.7*_height,"QUIT",true,
					      QuitToDesktop,-1,
						  QuitToDesktop,-1);
for(var i=0; i<array_length(options); i++)
{
	options[i].enabled = false;
}

/*
function GUIButton(_x=0,_y=0, _sprite=-1, _text="",_width=20,_height=100) constructor{
	sprite = _sprite;
	focus = false;
	image = 0;
	text = _text;
	textColor = c_white;
	x = _x;
	y = _y;
	width = sprite== -1 ? _width : sprite_get_width(sprite);
	height = sprite== -1 ? _height : sprite_get_height(sprite);
}

// set up menu options
var _width = display_get_gui_width();
var _height = display_get_gui_height();
var _buttonWidth = 100;
var _buttonHeight = 20;
options = [ new GUIButton(0.5*_width,0.5*_height,"PLAY",_buttonWidth,_buttonHeight), 
            new GUIButton(0.5*_width,0.5*_height,"PLAY",_buttonWidth,_buttonHeight),
			new GUIButton(0.5*_width,0.5*_height,"PLAY",_buttonWidth,_buttonHeight),
			new GUIButton(0.5*_width,0.5*_height,"PLAY",_buttonWidth,_buttonHeight),
			new GUIButton(0.5*_width,0.5*_height,"PLAY",_buttonWidth,_buttonHeight),
			];

//options = ["PLAY", "LEVEL SELECT", "SETTINGS", "QUIT"];


