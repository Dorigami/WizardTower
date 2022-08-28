/// @description 
// follow camera
x = camera_get_view_x(view_camera[0]);// global.iCamera.x-viewWidthHalf;
y = camera_get_view_y(view_camera[0]);//global.iCamera.y-viewHeightHalf;
// Inherit the parent event
event_inherited();

if(fadeIn)
{
	// fade in
	if(image_alpha != 1) image_alpha = min(1, image_alpha + 0.05);
}
