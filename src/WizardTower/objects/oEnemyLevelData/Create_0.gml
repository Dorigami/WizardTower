/// @description Insert description here
// You can write your code in this editor


level_content = undefined;
level_started = false;
wave_count = 0;
wave_count_max = 0;
wave_time = 10;
wave_time_check = current_time;
force_next_wave = false;
init = false;
wave_structs = ds_list_create();


// Command Queue for objects to interface with
command_queue = ds_queue_create();

// scripts that will allow other objects to control this object
EnemyLevelDataCallScripts();

// internal scripts
function update_tick(){

}

function set_current_wave(_ind){
	wave_count = 0;
}