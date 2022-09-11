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
		targetHover = noone;
	}
}
if(mouse_check_button_released(mb_left)) || (mouse_check_button_released(mb_right))
{
	// only update the buttons if the player clicks outside of the UI elements
	if(!point_in_rectangle(mouse_x,mouse_y,rectPurchase[0],rectPurchase[1],rectStart[2],rectStart[3]))
	{
		var _tgt = noone;
		if(mouse_check_button_released(mb_left)) _tgt = collision_point(mouse_x,mouse_y,pEntity,false,true); 
		targetClick = _tgt == noone ? false : true;
		targetHover = _tgt;
		UpdateUpgradeButtons();
	}
}
if(targetHover != targetHoverCheck) && (targetClick)
{
	targetHoverCheck = targetHover;
	UpdateUpgradeButtons();
}

// Inherit the parent event
event_inherited();

if(fadeIn)
{
	// fade in
	if(image_alpha != 1) image_alpha = min(1, image_alpha + 0.05);
}
