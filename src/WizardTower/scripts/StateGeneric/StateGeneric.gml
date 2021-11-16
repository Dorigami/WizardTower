function UnitFree(){
	if(stateCheck != state)
	{
		stateCheck = state;
	}
	var _lowest = 0;
	var _map = undefined;
	var _value = 0;

	depth = -y;
	allMasked = true;

	// update the target & destination
	if(instance_exists(target)) 
	{
		destination = vect2(target.x,target.y);
	} else {
		target = noone;
	}

	if(destination != -1) 
	{
		if(alarm[10] == -1) alarm[10] = pathUpdateDelay;
		destinationDistance = point_distance(position[1],position[2],destination[1],destination[2]);
	}
	// calculate context maps / steering
	if(destination != -1)
	{
		if(ds_exists(path, ds_type_list)) && (ds_list_size(path) > 1) && (myNode == path[| 0]) 
		{ 
			ds_list_delete(path, 0);
		}

		// clear context maps
		for(var i=0;i<resolution;i++) 
		{
			dangerMap[i] = 0;
			interestMap[i] = 0;
			mask[i] = false;
		}
		ds_list_clear(iSet);
		ds_list_clear(dSet);
		interest = 0;

		// calculate context maps
		// get danger of blocked nodes (enforce minimum distance)
		AvoidObstructions(x, y, true, true);
		
		// get danger of other followers
		csAvoid(oWizard);
		
		// get interest of goal
		csChasePath(path);

		// parse the context maps
		// combining interest and danger maps independantly to have an interest/danger pair
		// combine interest set
		for(var i=0;i<ds_list_size(iSet);i++)
		{
			_map = iSet[| i];
			for(var j=0;j<resolution;j++)
			{
				if(_map[j] > interestMap[j]) interestMap[j] = _map[j];
			}
		}
		// combine danger set
		for(var i=0;i<ds_list_size(dSet);i++)
		{
			_map = dSet[| i];
			for(var j=0;j<resolution;j++){ if(_map[j] > dangerMap[j]) dangerMap[j] = min(1, _map[j]) }
		}
	//--// merge danger and interest
		// find lowest danger value 
		for(var i=0;i<resolution;i++){ if(dangerMap[i] < _lowest) _lowest = dangerMap[i] }
		//// set the mask
		//for(var i=0;i<resolution;i++) { mask[i] = dangerMap[i] > _lowest ? 1 : 0 }
		//// reduce all danger values by the lowest value
		//for(var i=0;i<resolution;i++){ dangerMap[i] = dangerMap[i] - _lowest }

		// get a preferred direction
		for(var i=0;i<resolution;i++) 
		{
			if(mask[i]) continue;
			_value = max(0, interestMap[i] - dangerMap[i]);
			if(_value > interest) 
			{
				allMasked = false;
				interest = _value;
				direction = i*(360 div resolution);
			}
		}
	}
	
	//attack or interact
	if(target != noone)
	{
		if(destinationDistance <= statRange)
		{
		
		}
	}
	//arrive at destination
	if(destinationDistance <= 1*CELL_SIZE)
	{
		arrived = true;
		arrivalSlow = max(arrivalSlow - 0.04, 0);
	} else { arrivalSlow = 1 }

	// update position
	steering = speed_dir_to_vect2(steeringMag,direction);
	velocity = vect_truncate(vect_add(velocity, steering), statMspeed*interest*arrivalSlow);
	if(allMasked) velocity = vect2(0,0);
	position = vect_add(position,velocity);

	x = position[1];
	y = position[2];

	if(arrived) && (vect_len(velocity) == 0)
	{
		arrived = false;
		path = -1
		destination = -1;
		destinationDistance = 0;
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
