/// @description update camera

// update destination
if(instance_exists(follow))
{
	xTo = follow.x;
	yTo = follow.y;
}

// keep camera inside the room
//	xTo = clamp(xTo, viewWidthHalf, room_width - viewWidthHalf);
//	yTo = clamp(yTo, viewHeightHalf, room_height - viewHeightHalf);

// update object position
x += floor(pan_rate*(xTo - x));
y += floor(pan_rate*(yTo - y));

//screen shake
x += irandom_range(-shakeRemain, shakeRemain);
y += irandom_range(-shakeRemain, shakeRemain);

shakeRemain = max(0, shakeRemain - ((1/shakeLength)*shakeMagnitude));

//camera_set_view_size(cam_, _display_manager.ideal_width_*view_zoom_,_display_manager.ideal_height_*view_zoom_);
camera_set_view_pos(cam, x-viewWidthHalf, y-viewHeightHalf);

