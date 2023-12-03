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
			var _wave = level_content[$ _str];
			if(!is_undefined(_wave)) 
			{
				// create a variable to track timeline instance
				_wave[$ "instance"] = noone;
				// add wave data to the struct list
				ds_list_add(wave_structs, _wave);
			}
		}
		show_debug_message("Enemy Controller Init Successful");
	}
	exit;
}

if(global.game_state == GameStates.PLAY)
{
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
//1	level starts	
		var _time_passed = current_time - wave_duration_check;
//  1a		get next wave	
//    1aa		create a timeline to spawn mobs
//    1ab		set timer for whole wave
//  1b		when wave timer runs out, or when player forces it, loop to 1a	
		
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
}


	static Update = function(){
		var _all_complete = true, i;
		if(wave_timer > 0)
		{
			if(--wave_timer <= 0)
			{
				// set flag to start next wave
				if(wave_index < array_length(wave_keys)-1) start_next_wave = true;
			}
		}
		// if a wave ended, give a reward or check if there are any more
		if(wave_has_ended)
		{
			wave_has_ended = false;
			for(i=0; i<array_length(wave_keys); i++)
			{
				// break loop if any of the waves aren't complete
				if(!wave_content[$ wave_keys[i]].complete) { _all_complete = false; break; }
			}
			// do something if all waves are complete
			if(all_waves_complete)
			{
				show_debug_message("AI UPDATE FUNCTION HAS FOUND THAT ALL WAVES ARE COMPLETE");
			}
		}
		// check for input to start wave
		if(start_next_wave)
		{
			start_next_wave = false;
			StartWaveTimeline(wave_index+1);
		}
		// end the level
		if(all_waves_complete)
		{
			show_debug_message("YOU WON THE DEBUG ROOM!!!");
			audio_play_sound(snd_win,1,false);
			all_waves_complete = false;
		}
	}

