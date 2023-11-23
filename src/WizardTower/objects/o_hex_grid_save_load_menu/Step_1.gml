/// @description 

button_focus = -1;
//option_focus = -1;
mouse_gui_x = device_mouse_x_to_gui(0);
mouse_gui_y = device_mouse_y_to_gui(0);

for(var i=ds_list_size(button_list)-1; i>=0; i++){
	var obj = button_list[| i];
	if(is_undefined(obj)) 
	{
		ds_list_delete(button_list, i);
	} else {
		obj.Update();
	}
}

for(var i=ds_list_size(option_list)-1; i>=0; i++){
	var obj = option_list[| i];
	if(is_undefined(obj)) 
	{
		ds_list_delete(option_list, i);
	} else {
		obj.Update();
	}
}

if(mouse_check_button_pressed(mb_left))
{
	//if(button_focus > -1)
	//{} else if(optio)
}






