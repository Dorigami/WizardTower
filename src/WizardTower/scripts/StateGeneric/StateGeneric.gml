function UnitFree(){
	if(x != xTo) || (y != yTo)
	{
		var _dir = point_direction(x,y,xTo,yTo);
		var _dist = point_distance(x,y,xTo,yTo);
		if(_dist <= statMovespeed)
		{
			x = xTo;
			y = yTo;
			speed = 0;
		} else {
			speed = statMovespeed;
			direction = _dir;
		}
	}
}
function UnitSpawn(){
	if(stateCheck != state)
	{
		stateCheck = state;
		spawnProgress = 0;
		wait = 0;
		waitDuration = 60;
		flash = flashSpeed*waitDuration;
		image_alpha = 0;
	}
	image_alpha = min(1, image_alpha+0.04);
	
	spawnProgress = wait/waitDuration;
	if(++wait >= waitDuration)
	{
		state = STATE.FREE;
	}
}
function UnitDead(){
	if(stateCheck != state)
	{
		stateCheck = state;
		speed = 0;
		waitDuration = FRAME_RATE;
		wait = 0;
	}
	// remove from play
	if(++wait >= waitDuration)
	{
		// spawn a random powerup
		if(random(1) > 0.39)
		{
			SpawnPowerup(x,y,irandom(POWERUP.TOTAL-1));
		}
		instance_destroy();
	}
}
function StructureFree(){
	if(x != xTo) || (y != yTo)
	{
		var _dir = point_direction(x,y,xTo,yTo);
		var _dist = point_distance(x,y,xTo,yTo);
		if(_dist <= statMovespeed)
		{
			x = xTo;
			y = yTo;
			speed = 0;
		} else {
			speed = statMovespeed;
			direction = _dir;
		}
	}
}
function StructureSpawn(){
	if(stateCheck != state)
	{
		stateCheck = state;
		buildProgress = 0;
		image_alpha = 0.2;
	}
	
	if(buildProgress >= 1)
	{
		state = STATE.FREE;
		image_alpha = 1;
	}
}
function StructureDead(){
	if(stateCheck != state)
	{
		stateCheck = state;
		speed = 0;
		waitDuration = FRAME_RATE;
		wait = 0;
	}
	// remove from play
	if(++wait >= waitDuration)
	{
		// spawn a random powerup
		if(random(1) > 0.39)
		{
			SpawnPowerup(x,y,irandom(POWERUP.TOTAL-1));
		}
		instance_destroy();
	}
}
/*
function UnitInteract(){
	if(stateCheck != state)
	{
		stateCheck = state;
		speed = 0;
		waitDuration = 0.5*FRAME_RATE;
		wait = 0;
		//// deal damage
		//HurtPlayer(oPlayer.id, point_direction(x,y,oPlayer.x,oPlayer.y), 0, 2);
	}
	
	if(++wait >= waitDuration)
	{
		state = statePrevious;
	}
}
function UnitAttack(){
	if(stateCheck != state)
	{
		stateCheck = state;
		speed = 0;
		waitDuration = 0.5*FRAME_RATE;
		wait = 0;
		// deal damage
		HurtPlayer(oPlayer.id, point_direction(x,y,oPlayer.x,oPlayer.y), 0, 2);
	}
	
	if(++wait >= waitDuration)
	{
		state = statePrevious;
	}
}
