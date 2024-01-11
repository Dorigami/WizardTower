/// @description 

event_inherited();

// title fade in variables
title = "VICTORY!!!";
title_sub = "select an option using \"W\" & \"S\" or [up key] & [down key]\nconfirm option using [spacebar] or [enter]";
intro = true;
intro_time = 10;
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

LabelAdd(-(0.5*string_width(title)),-80,id,0,"title",,title);
LabelAdd(-(0.5*string_width(title_sub)),-60,id,0,"title_sub",,title_sub);
var _sprite = sBtn40x32;
ButtonAdd(-(0.5*sprite_get_width(_sprite)),-20,id,1,"restart",_sprite,,"RESTART",,GoToLevel,[rHexTest]);
ButtonAdd(-(0.5*sprite_get_width(_sprite)),20,id,2,"credits",_sprite,,"CREDITS",,victory_menu_scripts,[rHexTest]);
ButtonAdd(-(0.5*sprite_get_width(_sprite)),60,id,3,"quit",_sprite,,"QUIT",,QuitToDesktop,[rHexTest]);

controlsList[| 1].enabled = 1;
controlsList[| 2].enabled = 1;
controlsList[| 3].enabled = 1;



