/// @description update mouse hud focus

mx = device_mouse_x_to_gui(0);
my = device_mouse_y_to_gui(0);

global.hud_focus = -1;
if(point_in_rectangle(mx,my,minimap_bbox[0],minimap_bbox[1],minimap_bbox[2],minimap_bbox[3])){ global.hud_focus = HUDFOCUS.MINIMAP }
if(point_in_rectangle(mx,my,player_data_bbox[0],player_data_bbox[1],player_data_bbox[2],player_data_bbox[3])){ global.hud_focus = HUDFOCUS.PLAYERDATA }
if(point_in_rectangle(mx,my,abilities_bbox[0],abilities_bbox[1],abilities_bbox[2],abilities_bbox[3])){ global.hud_focus = HUDFOCUS.ABILITIES }

// press the action buttons when respective hotkey is pressed
with(global.iEngine)
{
	for(var i=0;i<9;i++)
	{
		var btn = other.abilities_buttons[i];
		btn.press_override = keyboard_check(ord(ability_hotkeys[i]));
	}
}
