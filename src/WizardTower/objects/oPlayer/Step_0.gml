/// @description 
if(!global.gamePaused)
{
	if(state == STATE.FREE)
	{
		if(radialTarget != noone) && instance_exists(radialTarget)
		{
		
		}
	}	
//--// CONTROLS
	// check for inputs from the current control scheme
	if(controlScheme != -1) script_execute(controlScheme);
	
}

