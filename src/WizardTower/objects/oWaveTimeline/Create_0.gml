/// @description

/*
	wave_content
	wave_index = 0; // used to get the spawn data (content) for the wave corresponding to this index
    wave_keys = variable_struct_get_names(wave_content); // array of keys for accessing the spawn data for specific waves
	wave_content_end = false;
	wave_content_timer = -1;
	wave_content_index = 0; // used in the moment spawn function to create the entities
	wave_content_keys = variable_struct_get_names(wave_content[$ wave_keys[wave_index]]);
	wave_running = false;
	wave_complete = false;
	wave_timeline = undefined;
*/

// function to spawn entities from the timeline
function SpawnMoment(){
	var _arr = moment_list[| moment_index++];
	show_debug_message("Moment {0} reached in timeline.  array is: {1}", moment_index-1, _arr);
	
	var _struct = {
		owner : id,
		wave_index : wave_index,
		spawn_index : 0,
		spawn_data : _arr,
		spawn_node_index : _arr[0]
	}
	ds_list_add(spawner_list, instance_create_layer(0,0,"Instances",oEnemyLevelDataSpawner,_struct));
	
	// check if the timeline finished
	if(moment_index >= moment_count)
	{
		var _wave_content = owner.wave_structs_list[| wave_index];
		_wave_content.instance = noone;
		instance_destroy();
	}
}

// process the wave data passed to this object
// wave_data = {struct};
// wave_index = 0;

// initialize the timeline for the given wave 
var _name = "";
var _non_time_keys = 0;
var _step = 0;
wave_keys = variable_struct_get_names(wave_data);
wave_timeline = timeline_add();
moment_index = 0;
moment_count = array_length(wave_keys);
moment_list = ds_list_create();
entity_list = ds_list_create();
spawner_list = ds_list_create();

// let the hud object know to display wave data
with(global.iHUD)
{
	if(!show_wave_data) show_wave_data = true;
}

// add moments to the timeline
for(var j=0; j<moment_count; j++)
{
	_name = wave_keys[j];
	if(string_count("ms", _name) == 1){
		// skip the non time keys when setting moments, it is meant to hold an instance id for this object
		_step = real(string_copy(wave_keys[j], 3, string_length(wave_keys[j]))) // milliseconds
		_step = round(_step*FRAME_RATE*0.001); // frames per millisecond

		timeline_moment_add_script(wave_timeline, _step, SpawnMoment);
		ds_list_add(moment_list, wave_data[$ wave_keys[j]]);
		show_debug_message("moment added to wave timeline | step = {0} | array = {1}", _step, wave_data[$ wave_keys[j]])
	} else {
		show_debug_message("NON TIME KEY FOUND");
		// keep count of non time keys
		_non_time_keys++;
		// get general timer for the wave
		if(_name == "time")
		{
			//set wave timer for the actor
			_step = round(wave_data[$ "time"]*FRAME_RATE*0.001);
			owner.ai.wave_timer = _step;
		}
	}
}

// decrease the moment count based on number of non time keys
moment_count -= _non_time_keys;

// set and start timeline
timeline_index = wave_timeline;
timeline_running = true;

show_debug_message("moment count:{0} | running:{1}, name:{2} | max_moment:{3}", moment_count, timeline_running, timeline_get_name(timeline_index), timeline_max_moment(timeline_index));

