/// @description Control the Button
controlsCount = ds_list_size(controlsList)
if(controlsCount > 0)
{
	for(var i=0; i<controlsCount; i++)
	{
		var _ctrl = controlsList[| i];
		_ctrl.Update();
	}
}

/*

if(!enabled)
{
	if(image_index != 0) image_index = 0;
	if(textColor != baseColor) textColor = baseColor;
} else {
	// pick an image
	if(!focus)
	{
		image_index = 0;
		press = false;
		textColor = baseColor;
	} else {
		if(point_in_rectangle(mouse_x,mouse_y,bbox_left,bbox_top,bbox_right,bbox_bottom))
		{
			// animate button
			if(mouse_check_button(mb_any)) 
			{
				press = true;
			} else {
				press = false;
			}
			// register clicks
			if(mouse_check_button_released(mb_left)) 
			{
				press = false;
				leftClick = true;
			}
			if(mouse_check_button_released(mb_right)) 
			{
				press = false;
				rightClick = true;
			}
		}
		textColor = highlightColor;
		image_index = 1;
		if(press)
		{
			image_index = 2;
		}
	}

	if(image_index == 0){
		textOffsetY = 0;
	} else if(image_index == 1){
		textOffsetY = 1;
	} else if(image_index == 2){
		textOffsetY = 3;
	}

	// perform actions
	if(leftClick)
	{
		leftClick= false;
		if(leftScript != -1) script_execute_array(leftScript, leftArgs);
	}
	if(rightClick)
	{
		rightClick= false;
		if(rightScript != -1) script_execute_array(rightScript, rightArgs);
	}
}
