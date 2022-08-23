/// @description 


// Inherit the parent event
event_inherited();

// tab to next txt box
if(keyboard_check_pressed(vk_tab)) || (keyboard_check_pressed(vk_down))
{
	controlsFocus++
	if(controlsFocus >= 16)
	{
		controlsFocus = 0;
	} else if(controlsFocus > 7) 
	{
		controlsFocus = 16;
	}
}
if(keyboard_check_pressed(vk_tab) && keyboard_check_pressed(vk_shift)) || (keyboard_check_pressed(vk_up))
{
	controlsFocus--
	if(controlsFocus < 0)
	{
		controlsFocus = 16;
	} else if(controlsFocus > 7) 
	{
		controlsFocus = 7;
	}
}

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

