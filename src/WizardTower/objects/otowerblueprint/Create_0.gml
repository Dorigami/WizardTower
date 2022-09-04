/// @description 
depth = MENUDEPTH;
// this object will get the variable 'towerObj' 
// set by whatever creates the blueprint.  
if(is_undefined(towerObj)) 
{
	show_debug_message("blueprint error: towerObj not set");
	instance_destroy();
	exit;
} else {
	show_debug_message("blueprint created");
}
sprite = object_get_sprite(towerObj);
rect = [0,0,0,0];


