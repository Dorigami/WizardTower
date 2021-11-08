/// @description update to player's new position

cam = view_camera[0];
follow = noone;
viewWidthHalf = 0.5*camera_get_view_width(cam);
viewHeightHalf = 0.5*camera_get_view_height(cam);

//if(instance_exists(oPlayer))
//{
//	with(oPlayer)
//	{
//		other.follow = id
//		other.x = x;
//		other.y = y;
//	}
//}

/*

if(follow == noone)
{
	xTo = 0.5*room_width;
	yTo = 0.5*room_height;
	x = xTo;
	y = yTo;
}

