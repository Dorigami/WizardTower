/// @description Level Setup on playspace

// setup view
with(global.iCamera)
{
	camera_set_view_size(view_camera[0], RESOLUTION_W, RESOLUTION_H);
	xTo = round(0.5*room_width);
	yTo = round(0.5*room_height);
	x = xTo;
	y = yTo;
}
