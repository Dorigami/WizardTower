/// @description 

if(room != rShaderTest) exit;

//ShadeInitializeDisplay(1);
camera_set_view_size(view_camera[0],idealWidth*view_zoom, idealHeight*view_zoom);

var _x = room_width div 2;
var _y = room_height div 2;

x = 0;
y = 0;
with(global.iEngine)
{
	//InitializeDisplay(1, 1);
	var _cam = view_camera[0];
	
	with(global.iCamera)
	{
		cam = view_camera[0];
		viewWidthHalf = round(0.5*camera_get_view_width(cam));
		viewHeightHalf = round(0.5*camera_get_view_height(cam));
		x = _x; y = _y;
		xTo = x; yTo = y;
	}
}


show_debug_message("room dim = [{0}, {1}]\ncamera dim = [{2}, {3}]  cam pos = [{4}. {5}]\nideals = [{6}, {7}]\n surface dim = [{8}, {9}]", 
	room_width, 
	room_height, 
	camera_get_view_width(view_camera[0]),
	camera_get_view_height(view_camera[0]),
	camera_get_view_x(view_camera[0]),
	camera_get_view_y(view_camera[0]),
	idealWidth,
	idealHeight,
	surface_get_width(application_surface),
	surface_get_height(application_surface),
	);

