/// @description 


// Inherit the parent event
event_inherited();

if(mouse_check_button_pressed(mb_any))
{
	// destroy if click off of the menu
	if(!point_in_rectangle(mouse_x,mouse_y,x,y-tabHeight,x+width,y+height)) 
	{
		instance_destroy();
		exit;
	}
}

if(mouse_check_button_pressed(mb_left))
{
	// click on top tab to drag position 
	if(point_in_rectangle(mouse_x,mouse_y,x,y-tabHeight,x+width,y))
	{
		mouseOffsetX = x - mouse_x;
		mouseOffsetY = y - mouse_y;
		tabDrag = true;
	}
}
if(mouse_check_button_released(mb_left))
{
	if(tabDrag) tabDrag = false; 
}

