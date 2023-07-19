/// @description set up camera

cam = view_camera[0];
bbox = [0,0,0,0];
follow = noone;
viewWidthHalf = 0.5*camera_get_view_width(cam);
viewHeightHalf = 0.5*camera_get_view_height(cam);

spd = 6;
spdFast = 12;

xTo = x;
yTo = y;
pan_rate = 0.15;
zoom_rate = 0.15;

shakeLength = 0;
shakeMagnitude = 0;
shakeRemain = 0;
