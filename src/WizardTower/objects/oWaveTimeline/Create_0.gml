/// @description

/*
	Data Set By Creator/Owner:
		owner
		wave_data
		wave_index
*/

// function to spawn entities from the timeline
function SpawnMoment(){
	var _arr = moment_list[| moment_index++];
	// show_debug_message("Moment {0} reached in wave{1} timeline.  array is: {2}", moment_index-1, wave_index, _arr);
	// the last timestamp will contain an empty array, so make sure we dont make a spawner for it
	if(array_length(_arr) > 0)
	{
		var _struct = {
			owner : id,
			wave_index : wave_index,
			spawn_data : _arr,
			spawn_node_index : _arr[0]
		}
		ds_list_add(spawner_list, instance_create_layer(0,0,"Instances",oEnemyLevelDataSpawner,_struct));
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
moment_count = 0;
moment_list = ds_list_create();
entity_list = ds_list_create();
spawner_list = ds_list_create();

// let the hud object know to display wave data
with(global.iHUD)
{
	if(!show_wave_data) show_wave_data = true;
}

// add moments to the timeline
for(var j=0; j<array_length(wave_keys); j++)
{
	_name = wave_keys[j];
	if(string_count("ms", _name) == 1){
		// skip the non time keys when setting moments, it is meant to hold an instance id for this object
		_step = real(string_copy(wave_keys[j], 3, string_length(wave_keys[j]))) // milliseconds
		_step = round(_step*FRAME_RATE*0.001); // frames per millisecond

		timeline_moment_add_script(wave_timeline, _step, SpawnMoment);
		ds_list_add(moment_list, wave_data[$ wave_keys[j]]);
		moment_count++;
		//show_debug_message("moment added to wave timeline | step = {0} | array = {1}", _step, wave_data[$ wave_keys[j]])
	}
}

// set and start timeline
timeline_index = wave_timeline;
timeline_position = 0;
timeline_loop = false;
timeline_running = true;

//show_debug_message("Wave {0} Created", wave_index);
//show_debug_message("moment count:{0} | running:{1}, name:{2} | max_moment:{3}", moment_count, timeline_running, timeline_get_name(timeline_index), timeline_max_moment(timeline_index));

