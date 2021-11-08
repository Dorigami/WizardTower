/// @description 
var _lowest = 0;
var _map = undefined;
var _value = 0;
depth = -y;
allMasked = true;
speedMax = global.speed;

// interpolate density at current position
myNode = global.gridSpace[# x div CELL_SIZE, y div CELL_SIZE];
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
	csAvoid(oFollower2);
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

// update position
steering = speed_dir_to_vect2(steeringMag,direction);
velocity = vect_truncate(vect_add(velocity, steering), speedMax*interest);
if(allMasked) velocity = vect2(0,0);
position = vect_add(position,velocity);

x = position[1];
y = position[2];


// wobble the sprite when moving
var _len = vect_len(velocity);
if(_len == 0)
{
	moveWobble = 0;
} else {
	moveWobble += moveWobbleSpeed*(vect_len(velocity) / speedMax);
}
image_angle = 5*sin(moveWobble)

/*
	what do i do once this pathfinding effectively simulating crowd movements, my plan be to begin work on Wizard tower, following the feature plan that I made prior.  in order to call this algorithm good, I still need the following:
	1. the move speed of followers needs to be dependant on the density around them when the density is above a certain threashold.  
	2. followers need to maintain a minimum distance from each other
	3. followers need to maintain a minimum distance from walls(tilemap) and structures(objects) 
	4. followers need to maintain a minimum distance from walls(tilemap) and structures(objects) 
*/