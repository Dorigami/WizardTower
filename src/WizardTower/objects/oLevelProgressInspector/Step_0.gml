/// @description 

// update the distance to stretch the progress bar
middle_length = clamp(middle_length+(middle_length_goal-middle_length)*0.1, 27, 400);

if(target != noone)
{
	// check for new data to display
	if(target != target_check){ 
		target_check = target; 
		Init(); 
	}
}







