/// @description Insert description here
// You can write your code in this editor


level_content = undefined;
level_timeline = timeline_add();
wave_index = -1;
wave_total_count = 0;
wave_duration = 10;
wave_duration_check = current_time;
force_next_wave = false;
wave_has_ended = false;
init = false;
wave_structs_list = ds_list_create();
faction = ENEMY_FACTION;
all_waves_complete = false;
// Command Queue for objects to interface with
command_queue = ds_queue_create();

wave_time_0 = current_time;
wave_time_1 = 0;

// scripts that will allow other objects to control this object
EnemyLevelDataCallScripts();

// internal scripts
function start_wave(_ind){
		wave_time_1 = current_time;
		var _wave_content = wave_structs_list[| _ind];
		show_debug_message("startwavetimeline: ind={0} | time = {1}", _ind, wave_time_1 - wave_time_0);
		if(is_undefined(_wave_content)){ show_debug_message("ERROR: startwavetimeline - wave {0} is undefined", _ind); exit; }
		var _struct = {
			owner : id, // the object being created will have this to reference the actor making it
			wave_data : wave_structs_list[| _ind],
			wave_index : _ind
		}
		// if wave already has an instance, remove it
		// if(instance_exists(_wave_content.instance)) instance_destroy(_wave_content.instance);
		// create the timeline manager to spawn enemies from a given wave
		_wave_content.instance = instance_create_layer(0, 0, "Instances", oWaveTimeline, _struct);
}

function level_moment(){
	start_wave(++wave_index);
}