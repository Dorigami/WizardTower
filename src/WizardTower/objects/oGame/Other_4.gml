/// @description Level Setup on playspace
var _width = display_get_gui_width();
var _height = display_get_gui_height();
// setup view
with(global.iCamera)
{
	camera_set_view_size(view_camera[0], RESOLUTION_W, RESOLUTION_H);
	xTo = round(0.5*room_width);
	yTo = round(0.5*room_height);
	x = xTo;
	y = yTo;
}

// hud setup
if(room == rTest)
{
	CreateButton(oButtonGeneric,sBtn32x32,10,0.5*_height,"tower",true,-1,-1,-1,-1);
	CreateButton(oButtonGeneric,sBtn32x32,10,0.6*_height,"wall",true,-1,-1,-1,-1);
	CreateButton(oButtonGeneric,sBtn32x32,10,0.7*_height,"hut",true,-1,-1,-1,-1);
}