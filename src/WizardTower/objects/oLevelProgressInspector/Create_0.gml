/// @description 

middle_length = 0;
middle_length_goal = 200;

// target needs to be an instance id of the object controlling enemy spawn.
// based on current workflow, the object_index to look for would be oEnemyLevelData 
// which exists as part of the room when it's created
target = noone;
target_check = undefined;
target_data = undefined; // target data is what this inspector needs in order to draw to the screen

function Init(){
	show_debug_message("oLevelProgressInspector running Init() function");
}








