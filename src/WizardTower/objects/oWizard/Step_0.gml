/// @description 
var _lowest = 0;
var _map = undefined;
var _value = 0;

if(spawning) exit;

depth = -y;
allMasked = true;
if(destination != -1) destinationDistance = point_distance(position[1],position[2],destination[1],destination[2]);

// interpolate density at current position
myNode = global.gridSpace[# x div CELL_SIZE, y div CELL_SIZE];
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
	{// get danger of blocked nodes (enforce minimum distance)
		AvoidObstructions(x, y, true, true);
	}
	{// get danger of other followers
		csAvoid(oWizard);
	}
	{// get interest of goal
		csChasePath(path);
	}

	{ // parse the context maps
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
}

if(destinationDistance <= 1.5*CELL_SIZE)
{
	arrived = true;
	arrivalSlow = max(arrivalSlow - 0.04, 0);
} else { arrivalSlow = 1 }

// update position
steering = speed_dir_to_vect2(steeringMag,direction);
velocity = vect_truncate(vect_add(velocity, steering), stats.Mspeed*interest*arrivalSlow);
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

