/// @description update mouse hud focus

mx = device_mouse_x_to_gui(0);
my = device_mouse_y_to_gui(0);

global.hud_focus = -1;
if(point_in_rectangle(mx,my,minimap_bbox[0],minimap_bbox[1],minimap_bbox[2],minimap_bbox[3])){ global.hud_focus = HUDFOCUS.MINIMAP }
if(point_in_rectangle(mx,my,player_data_bbox[0],player_data_bbox[1],player_data_bbox[2],player_data_bbox[3])){ global.hud_focus = HUDFOCUS.PLAYERDATA }
if(point_in_rectangle(mx,my,abilities_bbox[0],abilities_bbox[1],abilities_bbox[2],abilities_bbox[3])){ global.hud_focus = HUDFOCUS.ABILITIES }
if(level_progress_id !=  noone)
{	// get focus on the inspector
	with(level_progress_id){ if(point_in_rectangle(other.mx,other.my,progress_bbox[0],progress_bbox[1],progress_bbox[2],progress_bbox[3])){global.hud_focus = HUDFOCUS.LEVELINSPECTOR} }
}
if(selection_inspector_id !=  noone)
{	// get focus on the inspector
	with(selection_inspector_id){ if(point_in_rectangle(other.mx,other.my,inspection_bbox[0],inspection_bbox[1],inspection_bbox[2],inspection_bbox[3])){global.hud_focus = HUDFOCUS.SELECTIONINSPECTOR} }
}

// press the action buttons when respective hotkey is pressed
with(global.iEngine)
{
	for(var i=0;i<9;i++)
	{
		var btn = other.abilities_buttons[i];
		btn.press_override = keyboard_check(ord(ability_hotkeys[i]));
	}
}

while(ds_queue_size(command_queue) > 0)
{
	var _cmd = ds_queue_dequeue(command_queue);
	// create visual effects based on the command pass to this HUD object 
	switch(_cmd.type)
	{
		case "increase money":
			var _money_string = "+$" + string_trim(string(_cmd.value),[".00","-"]);
			with(CreateFloatNumber(player_data_x+40, player_data_y+53,_money_string,FLOATTYPE.TICK,fDefault,90,30,0.1,true))
			{
				depth = other.depth-2;
			}
			break;
		case "decrease money":
			var _money_string = "-$" + string_trim(string(_cmd.value),[".00","-"]);
			with(CreateFloatNumber(player_data_x+40, player_data_y+55,_money_string,FLOATTYPE.TICK,fDefault,270,30,0.1,true))
			{
				image_blend = c_red;
				depth = other.depth-2;
			}
			break;
		case "increase_player_health":
			with(CreateFloatNumber(player_data_x+40, player_data_y+10,"+"+string_trim(string(_cmd.value),[".00","-"]),FLOATTYPE.TICK,fDefault,90+3*irandom_range(-5,5),30,0.1,true))
			{
				image_blend = c_green;
				depth = other.depth-2;
			}	
			break;
		case "decrease_player_health":
			with(CreateFloatNumber(player_data_x+40, player_data_y+13,"-"+string_trim(string(_cmd.value),[".00","-"]),FLOATTYPE.TICK,fDefault,270+3*irandom_range(-5,5),30,0.1,true))
			{
				image_blend = c_red;
				depth = other.depth-2;
			}	
			break;
	}
}
