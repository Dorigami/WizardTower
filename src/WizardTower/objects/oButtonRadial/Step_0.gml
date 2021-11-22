/// @description 

if(creator != noone)
{
	if(!instance_exists(creator)) instance_destroy();
	if(speed != 0) 
	{
		speed *= 0.60;
		image_alpha = min(image_alpha+0.06, 1);
	}
	// Inherit the parent event
	event_inherited();
}