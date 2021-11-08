/// @description set up camera

cam = view_camera[0];
follow = noone;
viewWidthHalf = 0.5*camera_get_view_width(cam);
viewHeightHalf = 0.5*camera_get_view_height(cam);

xTo = x;
yTo = y;

shakeLength = 0;
shakeMagnitude = 0;
shakeRemain = 0;
