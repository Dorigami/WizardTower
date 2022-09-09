/// @description 
// follow camera
x = camera_get_view_x(view_camera[0]);// global.iCamera.x-viewWidthHalf;
y = camera_get_view_y(view_camera[0]);//global.iCamera.y-viewHeightHalf;

// refresh target if one has not been clicked on
if(targetClick = false)
{
	targetHover = collision_point(mouse_x,mouse_y,pEntity,false,true);
} else {
	if(targetHover == noone) || (!instance_exists(targetHover)) 
	{
		targetClick = false;
		targetHover = noone
	}
}
if(mouse_check_button_released(mb_left))
{
	var _tgt = collision_point(mouse_x,mouse_y,pEntity,false,true);
	targetClick = _tgt == noone ? false : true;
	targetHover = _tgt;
}
// update areas to display info on the UI
var _y1 = y + RESOLUTION_H-64;
var _y2 = _y1 + 55;
rectPurchase[0] = x + 8;
rectPurchase[1] = _y1;
rectPurchase[2] = rectPurchase[0] + 160;
rectPurchase[3] = _y2;
rectUpgrade[0] = rectPurchase[2] + 1;
rectUpgrade[1] = _y1;
rectUpgrade[2] = rectUpgrade[0] + 180;
rectUpgrade[3] = _y2;
rectInfo[0] = rectUpgrade[2] + 1;
rectInfo[1] = _y1;
rectInfo[2] = rectInfo[0] + 180;
rectInfo[3] = _y2;
rectStart[0] = rectInfo[2] + 1;
rectStart[1] = _y1;
rectStart[2] = rectStart[0] + 100;
rectStart[3] = _y2;

// Inherit the parent event
event_inherited();

if(fadeIn)
{
	// fade in
	if(image_alpha != 1) image_alpha = min(1, image_alpha + 0.05);
}
