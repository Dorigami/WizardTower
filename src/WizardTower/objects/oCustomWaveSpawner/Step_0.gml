/// @description 

on_tab = point_in_rectangle(mouse_x,mouse_y,tab_bbox[0],tab_bbox[1],tab_bbox[2],tab_bbox[3]);
if(on_tab)
{
	if(!dragging[0]) && (mouse_check_button(mb_left))
	{
		dragging[0] = true;
		dragging[1] = mouse_x - x;
		dragging[2] = mouse_y - y;
	}

}
if(mouse_check_button_released(mb_left)){ dragging[0] = false }
if(dragging[0])
{
	x = mouse_x - dragging[1];
	y = mouse_y - dragging[2];
}

// Inherit the parent event
event_inherited();


x = clamp(x,global.game_grid_xorigin,global.game_grid_xorigin+global.game_grid_width*GRID_SIZE-1);
y = clamp(y,global.game_grid_yorigin,global.game_grid_yorigin+global.game_grid_height*GRID_SIZE-1);

tab_bbox[0] = x;
tab_bbox[1] = y-tab_hgt;
tab_bbox[2] = x+tab_wdt;
tab_bbox[3] = y;



