/// @description 

// update the distance to stretch the progress bar
middle_length = clamp(middle_length+(middle_length_goal-middle_length)*0.1, 50, 400);

if(target != noone)
{
	// check for new data to display
	if(target != target_check){ 
		target_check = target; 
		Init(target); 
	}
	if(step_script != -1) script_execute(step_script);
	
}







