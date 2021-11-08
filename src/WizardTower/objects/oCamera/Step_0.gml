/// @description update camera

if(!global.gamePaused)
{
	// update destination
	if(instance_exists(follow))
	{
		xTo = follow.x
		yTo = follow.y
	}

	// update object position
	x += 0.15*(xTo - x);
	y += 0.15*(yTo - y);

	//// keep camera inside the room
	//x = clamp(x, viewWidthHalf+TILE_SIZE, room_width - viewWidthHalf-TILE_SIZE);
	//y = clamp(y, viewHeightHalf+TILE_SIZE, room_height - viewHeightHalf-TILE_SIZE);

	//screen shake
	x += irandom_range(-shakeRemain, shakeRemain);
	y += irandom_range(-shakeRemain, shakeRemain);

	shakeRemain = max(0, shakeRemain - ((1/shakeLength)*shakeMagnitude));

	camera_set_view_pos(cam, x-viewWidthHalf, y-viewHeightHalf);
}
