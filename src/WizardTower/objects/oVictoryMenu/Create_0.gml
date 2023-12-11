/// @description 

event_inherited();

// title fade in variables
title = "WIZARD TOWER"
intro = true;
titleAlpha = 0;
optionAlpha = 0;
x = 0;
y = 0;
alarm[0] = FRAME_RATE*1;
alarm[1] = FRAME_RATE*2;

var _width = room_width; //display_get_gui_width();
var _height = room_height; //display_get_gui_height();

LabelAdd(0.5*_width-(0.6*string_width(title)),0.3*_height,id,0,"title",,title);
var _sprite = sBtn40x32;
ButtonAdd(0.5*_width-(0.5*sprite_get_width(_sprite)),0.5*_height,id,1,"play",_sprite,,"PLAY",,GoToLevel,[rTest]);
ButtonAdd(0.5*_width-(0.5*sprite_get_width(_sprite)),0.7*_height,id,2,"quit",_sprite,,"QUIT",,QuitToDesktop,[rTest]);

controlsList[| 1].enabled = false;
controlsList[| 2].enabled = false;

//optionFocus = 0;
//options[0] = CreateButton(oButtonGeneric,_sprite,0.5*_width-(0.5*sprite_get_width(_sprite)),0.5*_height,"PLAY",true,
//					      GoToLevel,[rTest],
//						  GoToLevel,[rTest]);
//options[1] = CreateButton(oButtonGeneric,_sprite,0.5*_width-(0.5*sprite_get_width(_sprite)),0.7*_height,"QUIT",true,
//					      QuitToDesktop,-1,
//						  QuitToDesktop,-1);
//for(var i=0; i<array_length(options); i++)
//{
//	options[i].enabled = false;
//}



