/// @description gravity & flash

/*

if(!global.gamePaused)
{
	var _x1 = x-0.5*sprite_width;
	var _x2 = _x1+sprite_width;
	var _y1 = y-20;
	var _y2 = _y1+1;
	hpRect = [_x1,_y1,_x2,_y2];
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

