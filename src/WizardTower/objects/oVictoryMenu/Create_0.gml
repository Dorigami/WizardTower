/// @description 

event_inherited();

// title fade in variables
title = "VICTORY!!!\n\nselect an option using \"W\" & \"S\" or [up key] & [down key]\nconfirm option using [spacebar] or [enter]"
intro = true;
intro_time = 1;
titleAlpha = 0;
optionAlpha = 0;
backdrop_alpha = 0;
x = global.iCamera.x;
y = global.iCamera.y;
halfwidth = global.iCamera.viewWidthHalf;
halfheight = global.iCamera.viewHeightHalf;
backdrop_bbox = [x-halfwidth,y-halfheight,x+halfwidth,y+halfheight];

alarm[0] = 0.5*intro_time;
alarm[1] = intro_time;

var _width = room_width; //display_get_gui_width();
var _height = room_height; //display_get_gui_height();

LabelAdd(x-(0.6*string_width(title)),0.3*_height,id,0,"title",,title);
var _sprite = sBtn40x32;
ButtonAdd(0,-40,id,1,"play",_sprite,,"Restart",,GoToLevel,[rHexTest]);
ButtonAdd(x-(0.5*sprite_get_width(_sprite)),0,id,2,"play",_sprite,,"Credits",,victory_menu_show_credits,[rHexTest]);
ButtonAdd(x-(0.5*sprite_get_width(_sprite)),40,id,3,"quit",_sprite,,"QUIT",,QuitToDesktop,[rHexTest]);

controlsList[| 1].enabled = false;
controlsList[| 2].enabled = false;
controlsList[| 3].enabled = false;



