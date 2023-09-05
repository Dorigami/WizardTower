DebugActorAI = function() constructor{
	wave_content = {
		wave1 : { // the 'key' in this struct is moment in milliseconds, the 'value' is an array of the units to spawn & their spawn location 
			time : 20000, 
			instance : noone,
			complete : false,
			ms1 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms5000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
			],
			ms10000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
			],
			ms15000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
			],
			ms20000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
			]
		},
		wave2 : {
			time : 22000, 
			instance : noone,
			complete : false,
			ms1 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1] 
			],
			ms5000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms10000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms15000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms20000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			]
		},
		wave3 : {
			time : 25000, 
			instance : noone,
			complete : false,
			ms1 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1] 
			],
			ms5000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms10000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms15000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms20000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			]
		},
		wave4 : {
			time : 250000, 
			instance : noone,
			complete : false,
			ms1 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1] 
			],
			ms5000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms10000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms15000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms20000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			]
		}
	}
	wave_cost_field = ds_grid_create(global.game_grid_width, global.game_grid_height);
	wave_paths = ds_list_create(); // list will contain structs of {name : "", x : 0, y : 0}
    command_timer = -1;
	command_timer_set_point = -1;
    commands = ds_list_create();
	owner = undefined;
	state = -1;
	wave_index = 0; // used to get the spawn data (content) for the wave corresponding to this index
    wave_keys = variable_struct_get_names(wave_content); // array of keys for accessing the spawn data for specific waves
	wave_index_limit = array_length(wave_keys)-1;
	wave_timer = -1;
	wave_time_limit = 0;
	wave_has_started = false;
	wave_has_ended = false;
	start_next_wave = false;
	all_waves_complete = false;

	static StartWaveTimeline = function(_ind=0){
		// indices start a 0 and go up
		wave_index = _ind;
		show_debug_message("startwavetimeline: {0} | by_index = {1} | by_string = {2} | wave keys = {3}", _ind, wave_content[$ _ind], wave_content[$ wave_keys[_ind]], wave_keys);
		var _wave = wave_content[$ "wave" + string(_ind)];
		if(is_undefined(_wave)){ show_debug_message("ERROR: startwavetimeline - wave {0} is undefined", wave_index); exit; }

		var _struct = {
			owner : owner, // the object being created will have this to reference the actor making it
			wave_data : _wave,
			wave_index : _ind
		}
		if(instance_exists(_wave.instance)) instance_destroy(_wave.instance);
		_wave.instance = instance_create_layer(0, 0, "Instances", oWaveTimeline, _struct);
	}
	static PauseWave = function(){
		if(timeline_exists(wave_timeline))
		{
			timeline_running = !timeline_running;
			wave_running = timeline_running;
		} else {
			wave_running = false;
		}
	}
	static GetAction = function(){
		// decide what command to make
		var _size = ds_list_size(owner.units);
		var _player_structures = global.iEngine.player_actor.structures;
		var _entity = undefined, _structure_entity = undefined, _target_found=false;
		
		for(var n=0; n<ds_list_size(_player_structures); n++)
		{
			// set flag if there is a base structure in the list
			_structure_entity = _player_structures[| n];
			if(!is_undefined(_structure_entity)) { _target_found = true; break; }
		}
		
		if(_size > 0) && (_target_found)
		{
			//show_debug_message("the enemy has {0} units", _size);
			for(var i=0;i<_size;i++){
				_entity = owner.units[| i];
				//show_debug_message("the enemy unit {0} = fighter:{1} | unit:{2} | structure:{3} | ai:{4} | faction list index:{5}", i, 
				//!is_undefined(_entity.fighter),
				//!is_undefined(_entity.unit),
				//!is_undefined(_entity.structure),
				//!is_undefined(_entity.ai),
				//_entity.faction_list_index);
				if(!is_undefined(_entity)) && (ds_list_size(_entity.ai.commands) == 0)
				{
					ds_list_add(_entity.ai.commands, new global.iEngine.Command("move",-4,_structure_entity.x, _structure_entity.y));
				}
			}
		}
	}

	static Init = function(){
		// create spawn points
		var _struct = undefined, _arr=undefined, _unit_arr = undefined;
		var i=0,j=0,k=0;
		for(i=0;i<ds_list_size(owner.structures);i++)
		{
			_struct = undefined;
			with(owner.structures[| i])
			{
				// this ai is not allowed to have a base
				if(type_string = "base")
				{
					instance_destroy();
				}
			}
		}
		// get paths & add them to the ai
		i = 0;
		// set random spawn positions for the wave content
		wave_index = 0; // used to get the spawn data (content) for the wave corresponding to this index
		wave_keys = variable_struct_get_names(wave_content); // array of keys for accessing the spawn data for specific waves
		wave_index_limit = array_length(wave_keys)-1;
		for(i=0;i<array_length(wave_keys);i++)
		{
			_struct = wave_content[$ wave_keys[i]];
			_arr = variable_struct_get_names(_struct);
			for(j=0;j<array_length(_arr);j++)
			{
				// check to see if the info at index 'j' is a spawn mob
				if(string_length(string_digits(_arr[j])) > 0)
				{
					_unit_arr = struct_get(_struct, _arr[j])
					for(k=0;k<array_length(_unit_arr);k++)
					{
						// set x value to the right edge of the game grid
						_unit_arr[k][1] = global.game_grid_xorigin + global.game_grid_width*GRID_SIZE + GRID_SIZE;
						// set y value to a random value within vertical bounds of the game grid
						_unit_arr[k][2] = global.game_grid_yorigin + irandom(global.game_grid_height)*GRID_SIZE ;
					}
					struct_set(_struct, _arr[j], _unit_arr);
				}
			}
		}
		// make sure the hud is displaying awve data
		with(global.iHUD)
		{
			if(!show_wave_data) show_wave_data = true;
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
	static Destroy = function(){
		
	}
}	

