function SB_pathlover(_goal_priority, _attack_priority, _density_priority, _discomfort_priority){
	// this function is assumed to be run inside of a unit entity
	// will update current node as position changes
	var i=0,j=0,k=0,v=0,interest=-100000000000,dist=0,ang=0,uAng=vect2(0,0),uVel=vect2(0,0);
	var speed_limit = fighter.speed*max(0, 1-move_penalty); // move penalty represents debuffs that affect movement speed
	var speed_terrain_penalty = 0; // this is how much movement is slowed in the desired direction, based on game grid parameters
	var _in_cell = point_in_rectangle(xx,yy,0,0,global.game_grid_width-1, global.game_grid_height-1)
	var _node = _in_cell ? global.game_grid[# xx, yy] : undefined;
	var _otherNode = undefined, _otherEntity = noone;
	var _neutral_density = global.iEngine.faction_entity_density_maps[| NEUTRAL_FACTION];
	var _ally_density = faction == PLAYER_FACTION ? global.iEngine.faction_entity_density_maps[| PLAYER_FACTION] : global.iEngine.faction_entity_density_maps[| ENEMY_FACTION];
	var _opponent_density = faction == PLAYER_FACTION ? global.iEngine.faction_entity_density_maps[| ENEMY_FACTION] : global.iEngine.faction_entity_density_maps[| PLAYER_FACTION];
	
	var _col_list = ds_list_create();
	var _halfgrid = GRID_SIZE div 2;
	var mask = array_create(CS_RESOLUTION,0);
	var _interest_map = array_create(CS_RESOLUTION,0);
	var _goal_map = array_create(CS_RESOLUTION,0);
	var _goal_desire = 0;
	var _attack_map = array_create(CS_RESOLUTION,0);
	var _attack_desire = 0;
	var _density_map = array_create(CS_RESOLUTION,0);
	var _density_desire = 0;
	var _density_max_value = 0;
	var _density_threshold = 2.2*GRID_SIZE;
	var _discomfort_map = array_create(CS_RESOLUTION,0);
	var _discomfort_desire = 0;
	var _discomfort_max_value = 0;
	
//--// 1) get direction and weight pointing toward unit's goal (the goal here would be the mob controller that this unit is a member of)
	if(instance_exists(member_of))
	{
		dist = point_distance(position[1], position[2], member_of.x, member_of.y);
		uAng = speed_dir_to_vect2(1, point_direction(position[1], position[2], member_of.x, member_of.y));
		_goal_desire = min(1.1, (dist/member_of.wander_radius)^2 - 0.2);
		for(k=0;k<CS_RESOLUTION;k++)
		{ 
			_goal_map[k] += vect_dot(global.iEngine.cs_unit_vectors[k], uAng); 
		}
	}
//--// 2) get direction and weight pointing toward nearest valid attack target
	if(!is_undefined(fighter.attack_target)) && (instance_exists(fighter.attack_target))
	{
		dist = point_distance(position[1], position[2], fighter.attack_target.position[1], fighter.attack_target.position[2]);
		uAng = speed_dir_to_vect2(1, point_direction(position[1], position[2], fighter.attack_target.position[1], fighter.attack_target.position[2]));
		_attack_desire = min(1.1, fighter.range*GRID_SIZE/dist);
		for(i=0;i<CS_RESOLUTION;i++)
		{ 
			 _attack_map[i] += max(0, vect_dot(global.iEngine.cs_unit_vectors[i], uAng)); 
		}
	}
	
	for(i=-1;i<2;i++){
	for(j=-1;j<2;j++){
		if(!point_in_rectangle(xx+i, yy+j, 0,0,global.game_grid_width-1,global.game_grid_height-1)) continue;
		_otherNode = global.game_grid[# xx+i, yy+j];
		dist = point_distance(position[1], position[2], _otherNode.x, _otherNode.y);
		ang = point_direction(position[1], position[2], _otherNode.x, _otherNode.y);
		uAng = speed_dir_to_vect2(1, ang);

		// get entities of otherNode and enforce mindistance
		v = ds_list_size(_otherNode.occupied_list);
		if(v > 0){ for(k=0;k<v;k++) ds_list_add(_col_list, _otherNode.occupied_list[| k]) }

		if(_otherNode.blocked) || (!_otherNode.walkable)
		{
			if(dist <= collision_radius+_halfgrid) if(!mask[ang div 8]) mask[ang div 8] = true;
		}
		
		for(k=0;k<CS_RESOLUTION;k++)
		{ 
//--// 3) get direction that minimizes unit density among allies
			// units distance is subtracted to cancel out its own contribution to node density
		    //_density_map[k] += max(0, (_ally_density[# xx+i, yy+j]-dist)*vect_dot(global.iEngine.cs_unit_vectors[k], uAng)); 
//--// 4) get direction that minimizes discomfort for the unit
			//_discomfort_map[k] += max(0, _otherNode.discomfort*vect_dot(global.iEngine.cs_unit_vectors[k], uAng));
		}
	}}
//--// 5) Normalize the density and discomfort maps (goal and attack maps are already normalized)
	for(i=0;i<CS_RESOLUTION;i++)
	{ 
		if(_density_max_value <= _density_map[i]) _density_max_value = _density_map[i];
		if(_discomfort_max_value <= _discomfort_map[i]) _discomfort_max_value = _discomfort_map[i];
	}
	for(i=0;i<CS_RESOLUTION;i++)
	{ 
		if(_density_max_value != 0) _density_map[i] = _density_map[i] / _density_max_value;
		if(_discomfort_max_value != 0) _discomfort_map[i] = _discomfort_map[i] / _discomfort_max_value;
	}
//--// 6) calculate the desire to avoid density and discomfort parameters
	_density_desire = 0;// clamp(_density_max_value / _density_threshold-1,0,1);
	_discomfort_desire = 0;// 1;

	// set final desired direction, scale down influence of the path flow direction based on distance from the path itself
	k = 0;
	uVel = vect_norm(vel_movement);
	for(i=0;i<CS_RESOLUTION;i++)
	{
		_interest_map[i] = _goal_priority*_goal_desire*_goal_map[i] + _attack_priority*_attack_desire*_attack_map[i] - 
				   		   _density_priority*_density_desire*_density_map[i] - _discomfort_priority*_discomfort_desire*_discomfort_map[i];
		
		if(interest < _interest_map[i])
		{  
			k = i; // this value is to remember the index of the desired direction
			uAng = global.iEngine.cs_unit_vectors[i];
			interest = _interest_map[i]; 
		}
		// cancel movement in masked directions
		if(mask[i]) && (vect_dot(uVel,global.iEngine.cs_unit_vectors[i]) > 0)
		{
			vel_movement = vect_subtract(vel_movement, vect_proj(vel_movement, global.iEngine.cs_unit_vectors[i]));
		}
	}

	// calculate new velocity with steering, there is no speed limit in cases where steering is pointed away from current velocity
	steering = vect_multr(uAng, steering_mag);
	vel_movement = vect_dot(uAng, vect_norm(vel_movement)) > 0 ? 
					vect_truncate(vect_add(vel_movement, steering), max(0, speed_limit*(1-speed_terrain_penalty))) :
					vect_add(vel_movement, steering);


    // simulate friction(deceleration) with respect to outside influences on movement
    if(vel_force[1] != 0) || (vel_force[2] != 0) vel_force = vect_multr(vel_force, vel_force_conservation);

    // update position based on velocities (forces and movement)
    position[1] = clamp(
					position[1] + vel_force[1] + vel_movement[1], 
					global.game_grid_xorigin, 
					global.game_grid_xorigin + global.game_grid_width*GRID_SIZE - 1);
    position[2] = clamp(
					position[2] + vel_force[2] + vel_movement[2], 
					global.game_grid_yorigin, 
					global.game_grid_yorigin + global.game_grid_height*GRID_SIZE - 1);
	x = position[1];
	y = position[2];
	
	for(i=0;i<ds_list_size(_col_list);i++)
	{
		EnforceMinDistance(_col_list[| i]);
	}
	
	EnforceTileCollision();
	
	ds_list_destroy(_col_list);
	
	// complete route
	if(position[1] <= global.game_grid_xorigin+1)
	{
		HurtPlayer();
		instance_destroy();
	}
}

function SB_Horizontal(_goal_priority, _attack_priority, _density_priority, _discomfort_priority){
	// this function is assumed to be run inside of a unit entity
	// will update current node as position changes
	var i=0,j=0,k=0,v=0,interest=-100000000000,dist=0,ang=0,uAng=vect2(0,0),uVel=vect2(0,0);
	var speed_limit = fighter.speed*max(0, 1-move_penalty); // move penalty represents debuffs that affect movement speed
	var speed_terrain_penalty = 0; // this is how much movement is slowed in the desired direction, based on game grid parameters
	var _in_cell = point_in_rectangle(xx,yy,0,0,global.game_grid_width-1, global.game_grid_height-1)
	var _node = _in_cell ? global.game_grid[# xx, yy] : undefined;
	var _otherNode = undefined, _otherEntity = noone;

	var _col_list = ds_list_create();

	var _halfgrid = GRID_SIZE div 2;
	var mask = array_create(CS_RESOLUTION,0);
	var _interest_map = array_create(CS_RESOLUTION,0);
	var _danger_map = array_create(CS_RESOLUTION,0);
	var _goal_map = array_create(CS_RESOLUTION,0);
	var _goal_desire = 0;
	var _attack_map = array_create(CS_RESOLUTION,0);
	var _attack_desire = 0;
	var _density_map = array_create(CS_RESOLUTION,0);
	var _density_desire = 0;
	var _density_max_value = 0;
	var _density_threshold = 2.2*GRID_SIZE;
	var _discomfort_map = array_create(CS_RESOLUTION,0);
	var _discomfort_desire = 0;
	var _discomfort_max_value = 0;
	
//--// 1) get direction and weight pointing toward unit's goal (the goal here would be the mob controller that this unit is a member of)
	uAng = vect2(-1, 0);
	_goal_desire = 1;
	for(k=0;k<CS_RESOLUTION;k++)
	{ 
		_goal_map[k] += vect_dot(global.iEngine.cs_unit_vectors[k], uAng); 
	}

//--// 2) get direction and weight pointing toward nearest valid attack target
	if(!is_undefined(fighter.attack_target)) && (instance_exists(fighter.attack_target))
	{
		dist = point_distance(position[1], position[2], fighter.attack_target.position[1], fighter.attack_target.position[2]);
		uAng = speed_dir_to_vect2(1, point_direction(position[1], position[2], fighter.attack_target.position[1], fighter.attack_target.position[2]));
		_attack_desire = min(1.1, fighter.range*GRID_SIZE/dist);
		for(i=0;i<CS_RESOLUTION;i++)
		{ 
			 _attack_map[i] += max(0, vect_dot(global.iEngine.cs_unit_vectors[i], uAng)); 
		}
	}
	
	for(i=-1;i<2;i++){
	for(j=-1;j<2;j++){
		if(!point_in_rectangle(xx+i, yy+j, 0,0,global.game_grid_width-1,global.game_grid_height-1)) continue;
		_otherNode = global.game_grid[# xx+i, yy+j];
		dist = point_distance(position[1], position[2], _otherNode.x, _otherNode.y);
		uAng = speed_dir_to_vect2(1, point_direction(position[1], position[2], _otherNode.x, _otherNode.y));

		// get entities of otherNode and enforce mindistance
		v = ds_list_size(_otherNode.occupied_list);
		if(v > 0){ for(k=0;k<v;k++) ds_list_add(_col_list, _otherNode.occupied_list[| k]) }

		if(_otherNode.blocked) || (!_otherNode.walkable)
		{
			if(dist <= collision_radius+_halfgrid) if(!mask[ang div 8]) mask[ang div 8] = true;
		}

		for(k=0;k<CS_RESOLUTION;k++)
		{ 
//--// 3) get direction that minimizes unit density among allies
			// units distance is subtracted to cancel out its own contribution to node density
		    //_density_map[k] += max(0, (_ally_density[# xx+i, yy+j]-dist)*vect_dot(global.iEngine.cs_unit_vectors[k], uAng)); 
//--// 4) get direction that minimizes discomfort for the unit
			//_discomfort_map[k] += max(0, _otherNode.discomfort*vect_dot(global.iEngine.cs_unit_vectors[k], uAng));
		}
	}}

//--// 5) calculate the desire to avoid density and discomfort parameters
	_density_desire = 0;// clamp(_density_max_value / _density_threshold-1,0,1);
	_discomfort_desire = 0;// 1;

	// set final desired direction, scale down influence of the path flow direction based on distance from the path itself
	k = 0;
	uVel = vect_norm(vel_movement);
	for(i=0;i<CS_RESOLUTION;i++)
	{
		_interest_map[i] = _goal_priority*_goal_desire*_goal_map[i] + _attack_priority*_attack_desire*_attack_map[i] - 
				   		   _density_priority*_density_desire*_density_map[i] - _discomfort_priority*_discomfort_desire*_discomfort_map[i];
		if(interest < _interest_map[i])
		{ 
			k = i; // this value is to remember the index of the desired direction
			uAng = global.iEngine.cs_unit_vectors[i];
			interest = _interest_map[i];
		}
	}

	// calculate new velocity with steering, there is no speed limit in cases where steering is pointed away from current velocity
	steering = vect_multr(uAng, steering_mag);
	vel_movement = vect_truncate(vect_add(vel_movement, steering), max(0, speed_limit*(1-speed_terrain_penalty)));
	
	// cancel movement in masked directions
	for(i=0;i<CS_RESOLUTION;i++)
	{
		if(mask[i]) && (vect_dot(uVel,global.iEngine.cs_unit_vectors[i]) > 0)
		{
			vel_movement = vect_subtract(vel_movement, vect_proj(vel_movement, global.iEngine.cs_unit_vectors[i]));
		}
	}

    // simulate friction(deceleration) with respect to outside influences on movement
    if(vel_force[1] != 0) || (vel_force[2] != 0) vel_force = vect_multr(vel_force, vel_force_conservation);

    // update position based on velocities (forces and movement)
    position[1] = clamp(
					position[1] + vel_force[1] + vel_movement[1], 
					global.game_grid_xorigin, 
					global.game_grid_xorigin + global.game_grid_width*GRID_SIZE - 1);
    position[2] = clamp(
					position[2] + vel_force[2] + vel_movement[2], 
					global.game_grid_yorigin, 
					global.game_grid_yorigin + global.game_grid_height*GRID_SIZE - 1);
	x = position[1];
	y = position[2];
	
	for(i=0;i<ds_list_size(_col_list);i++)
	{
		EnforceMinDistance(_col_list[| i]);
	}
	
	EnforceTileCollision();
	
	ds_list_destroy(_col_list);
}

function SB_PlayerUnit(_goal_priority, _attack_priority, _density_priority, _discomfort_priority){
	// this function is assumed to be run inside of a unit entity
	// will update current node as position changes
	
	if(position[1] == xTo) && (position[2] == yTo) exit;
	
	var i=0,j=0,k=0,v=0,interest=-100000000000,dist=0,ang=0,uAng=vect2(0,0),uVel=vect2(0,0);
	var speed_limit = fighter.speed*max(0, 1-move_penalty); // move penalty represents debuffs that affect movement speed
	var speed_terrain_penalty = 0; // this is how much movement is slowed in the desired direction, based on game grid parameters
	var _in_cell = point_in_rectangle(xx,yy,0,0,global.game_grid_width-1, global.game_grid_height-1)
	var _node = _in_cell ? global.game_grid[# xx, yy] : undefined;
	var _otherNode = undefined, _otherEntity = noone;

	var _col_list = ds_list_create();

	var _halfgrid = GRID_SIZE div 2;
	var mask = array_create(CS_RESOLUTION,0);
	var _interest_map = array_create(CS_RESOLUTION,0);
	var _danger_map = array_create(CS_RESOLUTION,0);
	var _goal_map = array_create(CS_RESOLUTION,0);
	var _goal_desire = 0;
	var _attack_map = array_create(CS_RESOLUTION,0);
	var _attack_desire = 0;
	var _density_map = array_create(CS_RESOLUTION,0);
	var _density_desire = 0;
	var _density_max_value = 0;
	var _density_threshold = 2.2*GRID_SIZE;
	var _discomfort_map = array_create(CS_RESOLUTION,0);
	var _discomfort_desire = 0;
	var _discomfort_max_value = 0;
	
//--// 1) get direction and weight pointing toward unit's goal (the goal here would be the mob controller that this unit is a member of)
	var goaldist = point_distance(position[1],position[2],xTo,yTo);
	uAng = dist > collision_radius ? 
			speed_dir_to_vect2(1,point_direction(position[1],position[2],xTo,yTo)) :
			vect2(0, 0);
	_goal_desire = 1;
	for(k=0;k<CS_RESOLUTION;k++)
	{ 
		_goal_map[k] += vect_dot(global.iEngine.cs_unit_vectors[k], uAng); 
	}

//--// 2) get direction and weight pointing toward nearest valid attack target
	if(!is_undefined(fighter.attack_target)) && (instance_exists(fighter.attack_target))
	{
		dist = point_distance(position[1], position[2], fighter.attack_target.position[1], fighter.attack_target.position[2]);
		uAng = speed_dir_to_vect2(1, point_direction(position[1], position[2], fighter.attack_target.position[1], fighter.attack_target.position[2]));
		_attack_desire = min(1.1, fighter.range*GRID_SIZE/dist);
		for(i=0;i<CS_RESOLUTION;i++)
		{ 
			 _attack_map[i] += max(0, vect_dot(global.iEngine.cs_unit_vectors[i], uAng)); 
		}
	}
	
	for(i=-1;i<2;i++){
	for(j=-1;j<2;j++){
		if(!point_in_rectangle(xx+i, yy+j, 0,0,global.game_grid_width-1,global.game_grid_height-1)) continue;
		_otherNode = global.game_grid[# xx+i, yy+j];
		dist = point_distance(position[1], position[2], _otherNode.x, _otherNode.y);
		uAng = speed_dir_to_vect2(1, point_direction(position[1], position[2], _otherNode.x, _otherNode.y));

		// get entities of otherNode and enforce mindistance
		v = ds_list_size(_otherNode.occupied_list);
		if(v > 0){ for(k=0;k<v;k++) ds_list_add(_col_list, _otherNode.occupied_list[| k]) }

		if(_otherNode.blocked) || (!_otherNode.walkable)
		{
			if(dist <= collision_radius+_halfgrid) if(!mask[ang div 8]) mask[ang div 8] = true;
		}

		for(k=0;k<CS_RESOLUTION;k++)
		{ 
//--// 3) get direction that minimizes unit density among allies
			// units distance is subtracted to cancel out its own contribution to node density
		    //_density_map[k] += max(0, (_ally_density[# xx+i, yy+j]-dist)*vect_dot(global.iEngine.cs_unit_vectors[k], uAng)); 
//--// 4) get direction that minimizes discomfort for the unit
			//_discomfort_map[k] += max(0, _otherNode.discomfort*vect_dot(global.iEngine.cs_unit_vectors[k], uAng));
		}
	}}

//--// 5) calculate the desire to avoid density and discomfort parameters
	_density_desire = 0;// clamp(_density_max_value / _density_threshold-1,0,1);
	_discomfort_desire = 0;// 1;

	// set final desired direction, scale down influence of the path flow direction based on distance from the path itself
	k = 0;
	uVel = vect_norm(vel_movement);
	for(i=0;i<CS_RESOLUTION;i++)
	{
		_interest_map[i] = _goal_priority*_goal_desire*_goal_map[i] + _attack_priority*_attack_desire*_attack_map[i] - 
				   		   _density_priority*_density_desire*_density_map[i] - _discomfort_priority*_discomfort_desire*_discomfort_map[i];
		if(interest < _interest_map[i])
		{ 
			k = i; // this value is to remember the index of the desired direction
			uAng = global.iEngine.cs_unit_vectors[i];
			interest = _interest_map[i];
		}
	}

	// calculate new velocity with steering, there is no speed limit in cases where steering is pointed away from current velocity
	steering = vect_multr(uAng, steering_mag);
	vel_movement = vect_truncate(vect_add(vel_movement, steering), max(0, min(speed_limit*(1-speed_terrain_penalty), )));
	if(vect_len(vel_movement) <= goaldist)
	{
	    position[1] = xTo;
	    position[2] = yTo;
		vel_movement[1] = 0;
		vel_movement[2] = 0;
	} else {	
		// cancel movement in masked directions
		for(i=0;i<CS_RESOLUTION;i++)
		{
			if(mask[i]) && (vect_dot(uVel,global.iEngine.cs_unit_vectors[i]) > 0)
			{
				vel_movement = vect_subtract(vel_movement, vect_proj(vel_movement, global.iEngine.cs_unit_vectors[i]));
			}
		}
	}

    // simulate friction(deceleration) with respect to outside influences on movement
    if(vel_force[1] != 0) || (vel_force[2] != 0) vel_force = vect_multr(vel_force, vel_force_conservation);

    // update position based on velocities (forces and movement)
    position[1] = clamp(
					position[1] + vel_force[1] + vel_movement[1], 
					global.game_grid_xorigin, 
					global.game_grid_xorigin + global.game_grid_width*GRID_SIZE - 1);
    position[2] = clamp(
					position[2] + vel_force[2] + vel_movement[2], 
					global.game_grid_yorigin, 
					global.game_grid_yorigin + global.game_grid_height*GRID_SIZE - 1);
	x = position[1];
	y = position[2];
	
	for(i=0;i<ds_list_size(_col_list);i++)
	{
		EnforceMinDistance(_col_list[| i]);
	}
	
	EnforceTileCollision();
	
	ds_list_destroy(_col_list);
}

function CheckNodeChange(_entity){
	with(_entity)
	{
		// this function is assumed to be run inside of a unit entity
		// will update current node as position changes
		xx = (position[1]-global.game_grid_xorigin) div GRID_SIZE;
		yy = (position[2]-global.game_grid_yorigin) div GRID_SIZE;
		if(!point_in_rectangle(xx,yy,0,0,global.game_grid_width-1,global.game_grid_height-1)) exit;
		if(xx != xx_prev) || (yy != yy_prev)
		{
			var _newnode = global.game_grid[# xx, yy];
			var _oldnode = global.game_grid[# xx_prev, yy_prev];
			// check if new node is walkable, if so resolve collision
			
			// remove id from previous node
			if(!is_undefined(_oldnode))
			{
				ds_list_delete(_oldnode.occupied_list, ds_list_find_index(_oldnode.occupied_list, id));
			}
			
			ds_list_add(_newnode.occupied_list, id);
			xx_prev = xx;
			yy_prev = yy;
			if(!is_undefined(fighter)) 
			{
				fighter.FindEnemies();
			
				var _range = 8;
				var _node = undefined;
				for(var i=-_range;i<=_range;i++){
				for(var j=-_range;j<=_range;j++){
					if(!point_in_rectangle(xx+i, yy+j,0,0,global.game_grid_width-1,global.game_grid_height-1)) continue;
					_node = global.game_grid[# xx+i, yy+j];
					var _size = ds_list_size(_node.occupied_list);
					if(_size == 0) continue;
					for(var k=0; k<_size; k++)
					{
						_node.occupied_list[| k].fighter.FindEnemies();
					}
				}}
			}
			if(xx == 0) && (faction == ENEMY_FACTION)
			{
				with(oEnemyGoal)
				{
					enable_collision_checking = true;
				}
			}
			return true;
		}
		return false;
	}
}
function BlueprintSteering(){
// this function is assumed to be run inside of a unit entity
// will update current node as position changes

	/*	
		vel_movement = vect_truncate(vect_add(vel_movement, steering), speed_limit*(1-danger_map[_dirindex]));

		x = position[1];
		y = position[2];
	*/
}
function UnitSteering_Basic(){
// this function is assumed to be run inside of a unit entity
// will update current node as position changes
	var _dirindex = 0;
	var _map = undefined;
	var _value = 0;
	var validMove = false;
	var speed_limit = fighter.speed*max(0, 1-move_penalty);

	// don't steer when the goal is reached
	if(point_distance(position[1], position[2], xTo,yTo) <= collision_radius) exit;

	// clear context maps
	for(var i=0;i<CS_RESOLUTION;i++) 
	{
		danger_map[i] = 0;
		interest_map[i] = 0;
		mask[i] = false;
	}

	ds_list_clear(global.interest_set);
	ds_list_clear(global.danger_set);
	interest = -10;

	// calculate context maps
	CS_Avoid_Obstructions();
	CS_Move_To_Attack_Target();
	CS_Move_To_Goal();

	// combining interest and danger maps independantly to have an interest/danger pair
	// combine interest set
	for(var i=0; i<ds_list_size(global.interest_set); i++)
	{
		_map = global.interest_set[| i];
		for(var j=0;j<CS_RESOLUTION;j++)
		{
			if(_map[j] > interest_map[j]) interest_map[j] = _map[j];
		}
	}
	
	// combine danger set
	for(var i=0; i<ds_list_size(global.danger_set); i++)
	{
		_map = global.danger_set[| i];
		for(var j=0;j<CS_RESOLUTION;j++){ 
			if(_map[j] > danger_map[j]){ 
				danger_map[j] = min(1, _map[j]) 
			}
		}
	}

	// get a preferred direction, weighing interest and danger together
	for(var i=0;i<CS_RESOLUTION;i++) 
	{
		if(interest_map[i] <= 0) continue;
		if(validMove == false) validMove = true;
		_value = interest_map[i] - danger_map[i];
		if(_value >= interest) 
		{
			_dirindex = i;
			// in case of tied interest, pick one at random
			if(_value == interest) && (random(1) < 0.5) continue;
			// set new interest/direction to move
			interest = _value;
		} 
	}

	if(validMove)
	{
		// check if direction is masked
		if(mask[_dirindex])
		{
			show_debug_message("desired direction is masked in dirIndex {0}\n v0={1} | direction = {2}",_dirindex,vel_movement,vect_direction(vel_movement));
			vel_movement = vect_subtract(vel_movement, vect_mult(vel_movement, vect_proj(vel_movement, speed_dir_to_vect2(1,i*CS_RESOLUTION))));
			show_debug_message("v1={0} | direction = {1}",vel_movement,vect_direction(vel_movement));
			// vel_movement[1] = 0;
			// vel_movement[2] = 0;
		} else {
			// calculate new velocity with steering
			direction = _dirindex*(360 div CS_RESOLUTION);
			steering = speed_dir_to_vect2(steering_mag, direction);
			vel_movement = vect_truncate(vect_add(vel_movement, steering), speed_limit*(1-danger_map[_dirindex]));
		}
		// land on goal point
		var _dist = point_distance(x,y,xTo,yTo); 
		if(_dist < vect_len(vel_movement)) vel_movement = speed_dir_to_vect2(_dist, direction);
	}	

    // simulate friction(deceleration) with respect to outside influences on movement
    if(vel_force[1] != 0) || (vel_force[2] != 0) vel_force = vect_multr(vel_force, vel_force_conservation);
	
    // update position based on velocities (forces and movement)
    position[1] = clamp(position[1] + vel_force[1] + vel_movement[1], 0, global.game_grid_width*GRID_SIZE - 1);
    position[2] = clamp(position[2] + vel_force[2] + vel_movement[2], 0, global.game_grid_height*GRID_SIZE - 1);
	x = position[1];
	y = position[2];
}


