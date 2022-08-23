/// @description 

// allow dragging
if(tabDrag)
{
	x = clamp(mouse_x + mouseOffsetX, 0, room_width-width);
	y = mouse_y; //clamp(mouse_y + mouseOffsetY, 0, room_height-height);
}
