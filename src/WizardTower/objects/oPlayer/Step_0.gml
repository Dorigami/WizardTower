/// @description 
if(!global.gamePaused)
{
	// control the structure radial options if applicable
	if(radialTarget != noone) && instance_exists(radialTarget)
	{
		with(radialTarget)
		{
			if(radialOptions != -1) && (!radialActive) radialActive = true;
		}
	} else {
		radialTarget = noone;
	}
//--// CONTROLS
	// check for inputs from the current control scheme
	if(controlScheme != -1) script_execute(controlScheme);
	
}

