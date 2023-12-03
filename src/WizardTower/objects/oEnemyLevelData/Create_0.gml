/// @description Insert description here
// You can write your code in this editor


level_content = undefined;
level_started = false;
wave_count = 0;
wave_count_max = 0;
wave_duration = 10;
wave_duration_check = current_time;
force_next_wave = false;
init = false;
wave_structs = ds_list_create();


// Command Queue for objects to interface with
command_queue = ds_queue_create();

// scripts that will allow other objects to control this object
EnemyLevelDataCallScripts();

// internal scripts

function start_level(){
	level_started = true;
	wave_count = 0;
}
function start_wave(_ind){

}