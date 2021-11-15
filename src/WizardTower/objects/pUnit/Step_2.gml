/// @description gravity & flash

if(!global.gamePaused)
{
	depth = -bbox_bottom;
	// seecum to gravity
	if(z > 0)
	{
		z = max(z-grav, 0);
		if(gravEnabled) grav += 0.1;
	} else {
		if(gravEnabled) grav = 0.1;
	}
	flash = max(flash-flashSpeed, 0);
	invulnerable = max(0, invulnerable-1);
}

