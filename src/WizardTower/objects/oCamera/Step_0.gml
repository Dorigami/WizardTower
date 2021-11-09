/// @description update camera

var _up = keyboard_check(ord("W"));
var _left = keyboard_check(ord("A"));
var _down = keyboard_check(ord("S"));
var _right = keyboard_check(ord("D"));
var _fastPan = keyboard_check(vk_shift);
var _panSpeed = 4;
if(!global.gamePaused)
{
			direction = point_direction(0, 0, _right - _left, _down - _up);
			if(abs(_right - _left) || abs(_down - _up)) 
			{
				//show_debug_message("pan direction: " + string(direction) 
				//	              +"\nleft-right: "+ string(abs(_right - _left))
				//				  +"\ndown-up: "+ string(abs(_down - _up))
				//);
				follow = noone;
				xTo += lengthdir_x(_panSpeed+_fastPan*_panSpeed, direction);
				yTo += lengthdir_y(_panSpeed+_fastPan*_panSpeed, direction);
				x = xTo; 
				y = yTo;
			} 
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
