/// @description 

with(oCamera)
{
	other.x = x;
	other.y = y;
}

event_inherited();

// player input
//keyLeft = keyboard_check(vk_left) || keyboard_check(ord("A"));
//keyRight = keyboard_check(vk_right) || keyboard_check(ord("D"));
keyUp = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
keyDown = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
keySelect = keyboard_check(vk_space) || keyboard_check(vk_enter);
keySelectRelease = keyboard_check_released(vk_space) || keyboard_check_released(vk_enter);

// only allow an option to be selected
// if the intro is finished
if(!intro)
{
	if(keyUp)
	{
		//decrease or loop the controlsFocus
		controlsFocus--;
		if(controlsFocus < 1) controlsFocus = ds_list_size(controlsList) - 1;
		controlsList[| controlsFocus].focus = true;
	}
	if(keyDown)
	{
		//decrease or loop the controlsFocus
		controlsFocus++;
		if(controlsFocus >= ds_list_size(controlsList)) controlsFocus = 1;
	}

	if(controlsFocus > 0)
	{
		var _focus = false;
		for(var i=0;i<ds_list_size(controlsList);i++)
		{
			_focus = controlsFocus == controlsList[| i].index;
			controlsList[| i].color = _focus ? c_yellow : c_white;
			if(_focus)
			{
				if(keySelect) controlsList[| controlsFocus].image = 2;
				if(keySelectRelease) controlsList[| controlsFocus].activated = true;
			}
		}
	}
}

if(intro) // intro handling
{
	// end intro early
	if(keyUp) || (keyDown) || (keySelect) || (mouse_check_button_pressed(mb_any))
	{
		intro = false;
		titleAlpha = 1;
		optionAlpha = 1;
		controlsList[| 1].enabled = true;
		controlsList[| 2].enabled = true;
	}
	
	// fade in the options & title
	backdrop_alpha = min(0.40, backdrop_alpha+0.009);
	if(alarm[0] == -1) titleAlpha = min(1,titleAlpha+0.006);
	if(alarm[1] == -1) optionAlpha = min(1,optionAlpha+0.008);
	controlsList[| 0].alpha = titleAlpha;
	image_alpha = optionAlpha;
	
	// end intro when the text is full opacity
	if(titleAlpha == 1) && (optionAlpha == 1) 
	{
		show_debug_message("FADE IN DONE")
		intro = false;
		controlsFocus = 1
		controlsList[| 1].enabled = true;
		controlsList[| 2].enabled = true;
		controlsList[| 3].enabled = true;
	}
} else {
	show_debug_message("image alpha is: {0}", image_alpha);
}

