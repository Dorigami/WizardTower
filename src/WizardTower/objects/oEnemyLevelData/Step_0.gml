/// @description 

if(!init){
	init = true;
	if(!is_undefined(level_content)){
		var _level_wave_names = struct_get_names(level_content);
		var _wave_duration_sum = 0;
		var _wave_duration = 0;
		if(timeline_exists(level_timeline)) level_timeline = timeline_add();
		ds_list_clear(wave_structs_list);
		wave_index = -1;
		wave_total_count =  array_length(_level_wave_names);
		timeline_running = false;
		// get the structs for each wave
		for(var i=0;i<=array_length(_level_wave_names);i++)
		{
			var _str = "wave" + string(i);
			var _wave_content = level_content[$ _str];
			if(!is_undefined(_wave_content)) 
			{
				// sum up the timestamps in the wave content (this needs to be done before adding other variables to the struct)
				var _wave_content_names = struct_get_names(_wave_content);
				//show_debug_message("initializing {0}\nwave content names: {1}\nwave content: {2}", _str, _wave_content_names, _wave_content);
				for(var j=0;j<array_length(_wave_content_names);j++){
					// only process the index of this struct if the name contains a timestamp
					if(string_pos("ms", _wave_content_names[j]) == 0) continue;
					// find the overall duration of the given wave by finding the largest timestamp among the wave content
					var _time_string = _wave_content_names[j]
					var _time_real = real(string_copy(_time_string,3,string_length(_time_string)-2)); // milliseconds
					_time_real = round(_time_real*FRAME_RATE*0.001); // frames per millisecond
					_wave_duration = _time_real > _wave_duration ? _time_real : _wave_duration;
					//show_debug_message("getting time from struct names str={0} | real={1}", _time_string, _time_real);
				}
				// create a variable to track timeline instance
				_wave_content[$ "instance"] = noone;
				_wave_content[$ "complete"] = false;
				// add wave data to the struct list
				ds_list_add(wave_structs_list, _wave_content);
				
				// add a moment to spawn next wave at given timestamp, for every wave after the first
				timeline_moment_add_script(level_timeline, _wave_duration_sum, level_moment); 
				_wave_duration_sum += _wave_duration;
			}
			// indicate that init function has succeeded
			show_debug_message("Enemy Controller Init Successful");
		}
	} else {
		show_message("Error: oEnemyLevelData, there is no level data to initialize");
	}
	exit;
}

if(global.game_state == GameStates.PLAY)
{
	// handle commands
	if(ds_queue_size(command_queue) > 0)
	{
		var _cmd = ds_queue_dequeue(command_queue);
		switch(_cmd.type)
		{
			case "start_level":
				// re-init this object in order to set the timeline
				if(!timeline_exists(level_timeline)){ ds_queue_enqueue(_cmd); init = false; exit; }
				level_start();
				show_debug_message("Start Level command received by the enemy controller!");
				break;
			case "force_next_wave":
				force_next_wave = true;
				show_debug_message("Force Next Wave command received by the enemy controller!");
				break;
			default:
				show_debug_message("ERROR: Enemy controller cannot handle this command: {0}", _cmd);
				break;
		}
	}
	
	// run checks once the level has begun
	if(timeline_running){
		if(wave_has_ended)
		{
			// check if all waves have been completed
			wave_has_ended = false;
			all_waves_complete = true;
			var _str = "";
			for(var i=0;i<ds_list_size(wave_structs_list);i++)
			{
				if(all_waves_complete) all_waves_complete = wave_structs_list[| i].complete;
				_str += "["+string(i) + "] complete = " + string(wave_structs_list[| i].complete) + "\n";
			}
			//show_debug_message("Wave has Ended: \n{0}", _str);
		}
//1	level starts	
		var _time_passed = current_time - wave_duration_check;
//  1a		get next wave	
//    1aa		create a timeline to spawn mobs
//    1ab		set timer for whole wave
//  1b		when wave timer runs out, or when player forces it, loop to 1a	
		
		if(force_next_wave){
			force_next_wave = false;
			show_debug_message("forcing next wave");
		}
		if(all_waves_complete)
		{
			wave_index++
			set_game_victory();
			with(oWaveTimeline) instance_destroy();
		}
	}
}


