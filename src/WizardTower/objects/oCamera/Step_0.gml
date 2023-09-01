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
xTo = clamp(xTo, global.game_grid_xorigin + viewWidthHalf*_margin, global.game_grid_xorigin + GRID_SIZE*global.game_grid_width - viewWidthHalf*_margin);
yTo = clamp(yTo, global.game_grid_yorigin + viewHeightHalf*_margin, global.game_grid_yorigin + GRID_SIZE*global.game_grid_height - viewHeightHalf*_margin);

// update object position
x += floor(pan_rate*(xTo - x));
y += floor(pan_rate*(yTo - y));

//screen shake
x += irandom_range(-shakeRemain, shakeRemain);
y += irandom_range(-shakeRemain, shakeRemain);

shakeRemain = max(0, shakeRemain - ((1/shakeLength)*shakeMagnitude));

//camera_set_view_size(cam_, _display_manager.ideal_width_*view_zoom_,_display_manager.ideal_height_*view_zoom_);
camera_set_view_pos(cam, x-viewWidthHalf, y-viewHeightHalf);

