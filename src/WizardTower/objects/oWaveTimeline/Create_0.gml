/// @description

/*
	Data Set By Creator/Owner:
		owner
		wave_data
		wave_index
*/

// function to spawn entities from the timeline
function SpawnMoment(){
	var _arr = moment_arr[moment_index++][1];
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
		show_debug_message("wave#{0} | moment#{1} | data:{2}", wave_index, moment_index, _arr);
	}
}

// initialize the timeline for the given wave 
var _name = "";
var _non_time_keys = 0;
var _step = 0;
var _arr = [];
wave_keys = variable_struct_get_names(wave_data);
wave_timeline = timeline_add();
moment_index = 0;
moment_count = 0;
moment_arr = ds_list_create();
entity_list = ds_list_create();
spawner_list = ds_list_create();

// let the hud object know to display wave data
with(global.iHUD){ if(!show_wave_data) show_wave_data = true; }

// parse the wave data to get moment timestamp and spawn contents, stored in an array to be sorted afterward
for(var i=0; i<array_length(wave_keys); i++)
{
	_name = wave_keys[i];
	if(string_count("ms", _name) == 1){
		// skip the non time keys when setting moments, it is meant to hold an instance id for this object
		_step = real(string_copy(_name, 3, string_length(_name))) // milliseconds
		_step = round(_step*FRAME_RATE*0.001); // frames per millisecond
		_arr[moment_count] = [_step, wave_data[$ _name]];
		moment_count++;
	}
}

// sort the array of moments
	//show_debug_message("before sort: {0}",_arr);
moment_arr = merge_sort(_arr, 0);
	//show_debug_message("after sort: {0}", _arr);
	
// update the timeline with the moments
for(var i=0;i<moment_count;i++){ timeline_moment_add_script(wave_timeline, moment_arr[i][0], SpawnMoment); }

// set and start timeline
timeline_index = wave_timeline;
timeline_position = 0;
timeline_loop = false;
timeline_running = true;


