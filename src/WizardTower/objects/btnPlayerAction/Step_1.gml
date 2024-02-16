/// @description Control the Button
if(gui)
{
	// check for mouse position
	focus = point_in_rectangle(global.iHUD.mx,global.iHUD.my,bbox_left,bbox_top,bbox_right,bbox_bottom) 
} else {
	// do nothing
}
current_ability = global.iEngine.current_player_abilities[action_index];

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
		// animate button
		press = mouse_check_button(mb_any); 

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
		textColor = highlightColor;
		image_index = 1;
		if(press){ image_index = 2; }
	}
	
	if(focus_override){ textColor = highlightColor; image_index = 1; }
	if(press_override){ image_index = 2; }

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
	
	// DISPLAY INFORMATION IN A TEXT WINDOW
	if(global.iEngine.current_player_abilities[action_index].icon != -1) && (text_window_enabled)
	{
		if(focus)
		{
			if(!instance_exists(oTextWindow)) 
			{
				// create a new window
				var _struct = {
					target : id,
					ability : global.iEngine.current_player_abilities[action_index],
					bg_sprite : sDebugTextWindow9s,
				}
				with(global.iHUD) instance_create_depth(mx, my, depth-2, oTextWindow, _struct);
			} else {
				// reset the window's target
				with(oTextWindow)
				{
					if(target != other.id)
					{
						update_ability = true;
						ability = global.iEngine.current_player_abilities[other.action_index];
						target = other.id; 
					}
				}
			}
		}
	}
}
