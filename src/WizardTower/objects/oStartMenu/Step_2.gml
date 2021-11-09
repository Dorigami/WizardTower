/// @description animate buttons

for(var i=0; i< array_length(options); i++)
{
	var _mouseHover = noone;
	with(pButton)
	{
		if(point_in_rectangle(mouse_x,mouse_y,bbox_left,bbox_top,bbox_right,bbox_bottom))
		{
			_mouseHover = id;
		}
	}
	var _btn = options[i];
	if(_btn.id == _mouseHover)
	{
		optionFocus = i;
		_btn.focus = true;
		_btn.press = (keyboard_check(vk_space) || keyboard_check(vk_enter));
	} else {
		if(i == optionFocus)
		{
			_btn.focus = true;
			_btn.press = (keyboard_check(vk_space) || keyboard_check(vk_enter));
		} else {
			_btn.focus = false;
		}
	}
	
}