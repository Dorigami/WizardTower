/// @description update camera

if(room = rShaderTest) exit;

// update destination
if(instance_exists(follow))
{
	xTo = follow.x;
	yTo = follow.y;
}

// keep camera inside the room
var _margin = 0.5; // this is a percentage of the view size that will be a buffer between the camera and the edge of the playspace
xTo = clamp(xTo, cam_bounds[0] + viewWidthHalf*_margin, cam_bounds[2] - viewWidthHalf*_margin);
yTo = clamp(yTo, cam_bounds[1] + viewHeightHalf*_margin, cam_bounds[3] - viewHeightHalf*_margin);

// update object position
x += floor(pan_rate*(xTo - x));
y += floor(pan_rate*(yTo - y));

//screen shake
x += irandom_range(-shakeRemain, shakeRemain);
y += irandom_range(-shakeRemain, shakeRemain);

shakeRemain = max(0, shakeRemain - ((1/shakeLength)*shakeMagnitude));

//camera_set_view_size(cam_, _display_manager.ideal_width_*view_zoom_,_display_manager.ideal_height_*view_zoom_);
camera_set_view_pos(cam, x-viewWidthHalf, y-viewHeightHalf);

