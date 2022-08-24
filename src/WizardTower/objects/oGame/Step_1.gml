/// @description reset gridSpace values

// update the menu stack
if(ds_stack_size(menuStack) > 0)
{
	if(!instance_exists(ds_stack_top(menuStack)))
	{
		while(ds_stack_size(menuStack) > 0) && (!instance_exists(ds_stack_top(menuStack)))
		{
			var _inst = ds_stack_pop(menuStack);
			show_debug_message("menu popped out of stack - id = " + string(_inst));
		}
	}
}

// do context steering for all mobs
if(global.gamePaused) exit;


// calculate
with(pUnit)
{
	var _x, _y;
	var _lowest = 0;
	var _map = undefined;
	var _value = 0;
	allMasked = true;
	// refresh the path point(node) that should be followed
	// this is so that the points can be followed using context steering
	if(path != -1) && (path_exists(path))
	{
		newnum = clamp(
			ceil(pathNum*pathPos+0.0001),
			0,
			pathNum-1
		); //current point number in path
		// update which point to follow
		if(newnum != oldnum) || (newnum == 0)
		{
			var _pOld = pathNode;
			var _pNew = -1;
			// get new coordinates to follow
			pathNode = vect2(path_get_point_x(path, newnum), path_get_point_y(path, newnum)); // index of the next node to chase

			// get the normaized direction of the path
			if(newnum <= 0)
			{
				// set vect to initial direction
				_pOld = vect2(path_get_point_x(path, 0), path_get_point_y(path, 0))
				_pNew = vect2(path_get_point_x(path, 1), path_get_point_y(path, 1))
			} else {
				// only the next point needs to be set
				_pNew = pathNode
			}
			
			pathVect = speed_dir_to_vect2(1,
				point_direction(_pOld[1],_pOld[2],_pNew[1],_pNew[2])
			);
			show_debug_message("old: " + string(_pOld) + "     new: " + string(_pNew) + " " + string(pathVect));
			// update the old number
			oldnum = newnum;
		}
	} else {
		pathNode = -1;
	}

	// clear context maps
	for(var i=0;i<CS_RESOLUTION;i++) 
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
	csAvoidObj(pUnit);
	//csAvoidPoint(vect2(mouse_x,mouse_y));
	//csAvoid(pStructure);
	
	// get interest of goal
	if(pathNode != -1)
	{
		csChasePoint(pathNode);
	}
	// parse the context maps
	// combine interest set (danger set is combined independantly to contrast with interest set)
	for(var i=0;i<ds_list_size(iSet);i++)
	{
		_map = iSet[| i];
		for(var j=0;j<CS_RESOLUTION;j++)
		{
			if(_map[j] > interestMap[j]) interestMap[j] = _map[j];
		}
	}
	// combine danger set
	for(var i=0;i<ds_list_size(dSet);i++)
	{
		_map = dSet[| i];
		for(var j=0;j<CS_RESOLUTION;j++){ if(_map[j] > dangerMap[j]) dangerMap[j] = min(1, _map[j]) }
	}
//--// merge danger and interest
	// find lowest danger value 
	for(var i=0;i<CS_RESOLUTION;i++){ if(dangerMap[i] < _lowest) _lowest = dangerMap[i] }
	//// set the mask
	//for(var i=0;i<CS_RESOLUTION;i++) { mask[i] = dangerMap[i] > _lowest ? 1 : 0 }
	//// reduce all danger values by the lowest value
	//for(var i=0;i<CS_RESOLUTION;i++){ dangerMap[i] = dangerMap[i] - _lowest }

	// get a preferred direction
	for(var i=0;i<CS_RESOLUTION;i++) 
	{
		if(mask[i]) continue;
		_value = max(0, interestMap[i] - dangerMap[i]);
		if(_value > interest) 
		{
			allMasked = false;
			interest = _value;
			direction = i*(360 div CS_RESOLUTION);
		}
	}

	// update position
	steering = speed_dir_to_vect2(steeringMag,direction);
	velocity = vect_truncate(vect_add(velocity, steering), spd*interest);
	if(allMasked) velocity = vect2(0,0);
	position = vect_add(position,velocity);

	position[1] = clamp(position[1],0,GRID_WIDTH*TILE_SIZE);
	position[2] = clamp(position[2],0,GRID_WIDTH*TILE_SIZE);
	x = position[1];
	y = position[2];

	// update the path position
	var _len = vect_len(velocity);
	var _dot = vect_dot(vect_norm(velocity), pathVect)
	pathPos += (_len*_dot) / pathLen;
	if(pathPos >= 1) instance_destroy();

	// update grid position
	_x = position[1] div GRID_WIDTH;
	_y = position[2] div GRID_HEIGHT;  
	if(_x != gridX) || (_y != gridY)
	{
		gridX = _x;
		gridY = _y;
		// add id to the target list for towers in range
		var _node = global.gridSpace[# _x, _y];
		if(!is_undefined(_node)) && (ds_list_size(_node.towersIR) > 0)
		{
			for(var i=0;i<ds_list_size(_node.towersIR);i++)
			{
				// add instance to the towers' target list
				var _tower = node.towersIR[| i];
				if(!is_undefined(_tower)) && (instance_exists(_tower)) ds_list_add(_tower.targetList);
			}
		}	
	}
}
