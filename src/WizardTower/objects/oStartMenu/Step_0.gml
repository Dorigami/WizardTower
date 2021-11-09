/// @description 

// player input
//keyLeft = keyboard_check(vk_left) || keyboard_check(ord("A"));
//keyRight = keyboard_check(vk_right) || keyboard_check(ord("D"));
keyUp = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
keyDown = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
keySelect = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter);

// only allow an option to be selected
// if the intro is finished
if(!intro)
{
	if(keyUp)
	{
		//decrease or loop the optionFocus
		optionFocus--;
		if(optionFocus < 0) optionFocus = array_length(options) - 1;
		options[optionFocus].focus = true;
		if(!global.muteSound)
		{
			//audio_sound_gain(sndSelectionChange,global.sfxVolume,0);
			//audio_play_sound(sndSelectionChange,10,false);
		}
	}
	if(keyDown)
	{
		//decrease or loop the optionFocus
		optionFocus++;
		if(optionFocus >= array_length(options)) optionFocus = 0;
		if(!global.muteSound)
		{
			//audio_sound_gain(sndSelectionChange,global.sfxVolume,0);
			//audio_play_sound(sndSelectionChange,10,false);
		}
	}
	if(keySelect)
	{
		if(!global.muteSound)
		{
			//audio_sound_gain(sndSelectionConfirm,global.sfxVolume,0);
			//audio_play_sound(sndSelectionConfirm,10,false);
		}
		options[optionFocus].leftClick = true;
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
		for(var i=0;i<array_length(options);i++) options[i].enabled = true;
	}
	// fade in the options & title
	if(alarm[0] == -1) titleAlpha = min(1,titleAlpha+0.006);
	if(alarm[1] == -1) optionAlpha = min(1,optionAlpha+0.008);
	for(var i=0;i<array_length(options);i++) options[i].image_alpha = optionAlpha;
	
	// end intro when the text is full opacity
	if(titleAlpha == 1) && (optionAlpha == 1) 
	{
		intro = false;
		for(var i=0;i<array_length(options);i++) options[i].enabled = true;
	}
}

