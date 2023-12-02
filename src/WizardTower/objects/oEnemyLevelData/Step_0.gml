/// @description 

if(!init){
	if(!is_undefined(level_content)){
		var arr = struct_get_names(level_content);
		wave_count = 0;
		wave_count_max =  array_length(arr);
		level_started = false;
		// get the structs for each wave
		for(var i=0;i<array_length(arr);i++)
		{
			var _str = "wave" + string(i);
			if(!is_undefined(level_content[$ _str])) 
			{
				ds_list_add(_temp_list, level_content[$ _str]);
			}
		}
		
		show_debug_message("Enemy Controller Init Successful");
	}
	exit;
}

// handle commands
if(ds_queue_size(command_queue) > 0)
{
	var _cmd = ds_queue_dequeue(command);
	switch(_cmd.type)
	{
		case "start_level":
			level_started = true;
			set_current_wave(wave_count);
			break;
		default:
			show_debug_message("ERROR: Enemy controller cannot handle this command: {0}", _cmd);
			break;
	}
}

if(level_started){
	var _time_passed = current_time - wave_time_check;
	if(_time_passed >= wave_time) || (force_next_wave){
		force_next_wave = false;
		wave_time_check = current_time;
		wave_time = level_content;
	}
}




if(_time_passed > tick_time){
	// update time_check
	time_check = current_time;
	
	// handle the wave data
	
	// loop through each spaened enemy to perform updates
}

