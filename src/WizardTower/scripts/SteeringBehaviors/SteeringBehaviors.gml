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
			if(point_in_rectangle(xx_prev,yy_prev,0,0,global.game_grid_width-1,global.game_grid_height-1)) 
			{
				var _oldnode = global.game_grid[# xx_prev, yy_prev];
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
		}
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
function CS_Move_To_Goal(){
	// move along the path
	var _range = 3*engagement_radius;
	var _goaldist = point_distance(x, y, xTo, yTo); // distance to (xTo/yTo)
	var _goaldir = point_direction(x, y, xTo, yTo); // direction to (xTo/yTo) 
	var _map = array_create(CS_RESOLUTION, 0); // new map to be added to the set
	var _u = 0; // unit vector pointing to goal

	var _strength = clamp(1-_goaldist/(los_radius*GRID_SIZE),0.05,1);

	// generate interest map toward goal
	_u = speed_dir_to_vect2(1, _goaldir);
	for(var i=0;i<CS_RESOLUTION;i++){ _map[i] = vect_dot(global.iEngine.cs_unit_vectors[i], _u) }

	// add interest map to the main set
	ds_list_add(global.interest_set, _map);
}
function CS_Move_To_Attack_Target(){
	var _tgt = fighter.attack_target;
	if(_tgt != noone) && (instance_exists(_tgt))
	{
		// move along the path
		var _goal_vect = vect2(_tgt.position[1]-position[1], _tgt.position[2]-position[2]);


		var _goaldist = point_distance(position[1], position[2], _tgt.position[1], _tgt.position[2]); 
		var _goaldir = point_direction(_tgt.position[1], _tgt.position[2], position[1], position[2]); 
		var _map = array_create(CS_RESOLUTION, 0); // new map to be added to the set
		var _u = 0; // unit vector pointing to goal

		var _strength = clamp(1-_goaldist/(los_radius*GRID_SIZE), 0.05, 1);

		// generate interest map toward goal
		_u = speed_dir_to_vect2(1, _goaldir);
		for(var i=0;i<CS_RESOLUTION;i++){ _map[i] = _strength*vect_dot(global.iEngine.cs_unit_vectors[i], _u) }

		// add interest map to the main set
		ds_list_add(global.interest_set, _map);
	}
}
function CS_Avoid_Obstructions(){
	var _nodeList = ds_list_create();
	var _slow_radius = 1.8*GRID_SIZE;
	var _mask_radius = collision_radius;
	var _weight = 0;
	var _dist = 0; // distance
	var _dir = 0; // direction 
	var _node = undefined;
	var _map = 0; // new map to be added to the set
	var _uNode = 0; // unit vector to node point

	// get node & neighboring nodes, add them to a list
	for(var x_offset=-2;x_offset<=2;x_offset++){
	for(var y_offset=-2;y_offset<=2;y_offset++){
		// ensure node location is valid
		if(xx+x_offset < 0) || (xx+x_offset >= global.game_grid_width) || (yy+y_offset < 0) || (yy+y_offset >= global.game_grid_height) continue;
		
		// get node
		_node = global.game_grid[# xx+x_offset, yy+y_offset];
		if(x_offset == 0) && (y_offset == 0) continue;
		// loop through occupying entities
		if(ds_list_size(_node.occupied_list) > 0)
		{
			for(var i=0;i<ds_list_size(_node.occupied_list);i++)
			{
				var _inst = _node.occupied_list[| i];
				if(_inst == id) continue;
				_dist = point_distance(x, y, _inst.x, _inst.y);
				if(_dist > _slow_radius) continue;
				
				_map = array_create(CS_RESOLUTION, 0);
				_dir = point_direction(x, y, _inst.x, _inst.y);
				_uNode = speed_dir_to_vect2(1, _dir);
				_weight = 1-((_dist-_mask_radius)/(_slow_radius-_mask_radius)); // weight = 1 when within 30% of max range
				for(var j=0;j<CS_RESOLUTION;j++)
				{ 
					_map[j] = _weight*vect_dot(global.iEngine.cs_unit_vectors[j], _uNode);
					if(_dist <= _mask_radius) || (_map[j] >= 1) 
					{
						mask[j] = true;
						EnforceMinDistance(_inst);
					}
				}
				// add map to danger set
				ds_list_add(global.danger_set, _map);
			}
		}
		// loop through neighboring nodes
		if(x_offset == 0) && (y_offset == 0) continue;

		_dist = point_distance(x, y, _node.x, _node.y);
		if(_dist > _slow_radius) continue;
		if(_node.blocked) || (!_node.walkable)
		{
			_map = array_create(CS_RESOLUTION, 0);
			_dir = point_direction(x, y, _node.x, _node.y);
			_uNode = speed_dir_to_vect2(1, _dir);
			_weight = 1-((_dist-_mask_radius)/(_slow_radius-_mask_radius)); // weight = 1 when within 30% of max range
			for(var k=0;k<CS_RESOLUTION;k++)
			{ 
				_map[k] = _weight*vect_dot(global.iEngine.cs_unit_vectors[k], _uNode);
				if(_dist <= _mask_radius) && (_map[k] > 0) mask[k] = true;
			}
			// add map to danger set
			ds_list_add(global.danger_set, _map);
		} 
	}}
}

/*
	function sb_rules_grunt(){
		// this script should be placed into the IDLE state as well as the MOVE state
		var _inst = instance_place(x,y,par_enemy);
		var i=0, _x1=0, _y1=0,_x2=0, _y2=0, _ind=0, _num=0, _dir=0, _weight=0, _dist = 0;


	//--// don't stack with instances that share a parent
		if(state_ == IDLE)
		{
			if(_inst != noone)
			{
				_dist = point_distance(x,y,_inst.x,_inst.y);
				// adjust the steering vector
				if(_dist <= 1)
				{ 
					_dir = irandom(359);				
					steering_ = vect_add(steering_, sb_avoid(lengthdir_x(sb_speed_,_dir),lengthdir_y(sb_speed_,_dir),1));
				} else { 
					_weight = clamp(1 - _dist / personal_space_,0.05,0.6);
					steering_ = vect_add(steering_, sb_avoid(_inst.x,_inst.y,_weight));
				}
				// set steering vector
				steering_ = vect_truncate(steering_,sb_force_);
			}
			exit;
		}

	//--// AVOID ENEMIES when moving at the same time
		with(par_enemy)
		{
			if(id != other.id)
			{
				if(state_ == MOVE)
				{
					_dist = point_distance(x,y,other.x,other.y);
					_weight = clamp(1 - _dist / personal_space_,0.05,0.4);
					if(_dist <= personal_space_)
					{
						with(other)
						{
							steering_ = vect_add(steering_, sb_avoid(other.x,other.y,_weight));

							steering_ = vect_truncate(steering_,sb_force_);
						}
					}
				}
			}
		}
	
	//--// follow a path to the target
		if(path_exists(path_))
		{
			// find index of nearest point in the path
			_num = path_get_number(path_);
			_x1 = path_get_point_x(path_,0);
			_y1 = path_get_point_y(path_,0);
			for(i=1;i<_num;i++)
			{
				_x2 = path_get_point_x(path_,i);
				_y2 = path_get_point_y(path_,i);
				if(point_distance(x,y,_x2,_y2) <= point_distance(x,y,_x1,_y1)) _ind = i;
			}
			// seek the next point in the path
			_x1 = path_get_point_x(path_,clamp(_ind+1,0,_num));
			_y1 = path_get_point_y(path_,clamp(_ind+1,0,_num));
			steering_ = vect_add(steering_, sb_seek(_x1,_y1,1));
			steering_ = vect_truncate(steering_,sb_force_);
		}
	
	}
//////////////////////////////////////////////////////////////
context steering functions 
function AvoidObstructions(_x, _y, _blocked, _notWalkable){
	var _nodeList = ds_list_create();
	var _slow_radius = GRID_SIZE;
	var _mask_radius = GRID_SIZE-5;
	var _weight = 0;
	var _dist = 0;
	var _x2 = 0;
	var _y2 = 0;
	var _dist = 0; // distance
	var _dir = 0; // direction 
	var _node = undefined;
	var _map = 0; // new map to be added to the set
	var _uNode = 0; // unit vector to node point
	var _uMap = 0; // unit vector of context map
	var _xCell = _x div GRID_SIZE;
	var _yCell = _y div GRID_SIZE;
	// get node & neighboring nodes, add them to a list
	for(var xx=-1;xx<=1;xx++)
	{
	for(var yy=-1;yy<=1;yy++)
	{
		// ensure node location is valid
		if(_xCell+xx < 0) || (_xCell+xx >= GRID_WIDTH) || (_yCell+yy < 0) || (_yCell+yy >= GRID_HEIGHT) continue;
		// get node
		_node = global.gridSpace[# _xCell+xx, _yCell+yy];
		// add node to list to be evaluated
		ds_list_add(_nodeList, _node);
	}
	}
	// get danger values for each node
	if(ds_list_size(_nodeList) > 0)
	{
		for(var i=0;i<ds_list_size(_nodeList);i++)
		{
			_node = _nodeList[| i];
			_dist = point_distance(x,y,_node.center[1], _node.center[2]);
			if(_dist > _slow_radius) continue;
			if((_blocked) && (_node.blocked)) || ((_notWalkable) && (!_node.walkable))
			{
				_map = array_create(resolution, 0);
				_dir = point_direction(x,y,_node.center[1], _node.center[2]);
				_uNode = speed_dir_to_vect2(1,_dir);
				_weight = 1-((_dist-_mask_radius)/(_slow_radius-_mask_radius)); // weight = 1 when within 30% of max range
				for(var k=0;k<resolution;k++)
				{ 
					
					_map[k] = _weight*vect_dot(speed_dir_to_vect2(1,k*(360 div resolution)), _uNode);
					if(_dist <= _mask_radius) && (_map[k] > 0) mask[k] = true;
				}
				// add map to danger set
				ds_list_add(other.global.danger_set, _map);
			}
		}
	}
	ds_list_destroy(_nodeList);
}

function csChaseGoal(_goal){
	var _range = 2000;
	var _rangeWeight = 0;
	var resolution = 12;
	var _dist = 0; // distance
	var _dir = 0; // direction 
	var _map = 0; // new map to be added to the set
	var _uObj = 0; // unit vector of the object
	var _uMap = 0; // unit vector of context map
	// get interest values
	show_debug_message(string(_goal))
	_map = array_create(resolution, 0);
	_dist = point_distance(x,y,_goal[1],_goal[2]);
	if(_dist > _range) return;
	_rangeWeight = min(1,(1-(_dist/_range))/0.8); // weight = 1 when within 20% of max range
	_dir = point_direction(x,y,_goal[1],_goal[2]);
	_uObj = speed_dir_to_vect2(1,_dir);
	for(var i=0;i<resolution;i++)
	{
		_uMap = speed_dir_to_vect2(1,i*(360 div resolution))
		_map[i] = _rangeWeight*vect_dot(_uMap,_uObj);
	}
	ds_list_add(other.global.interest_set, _map);
}

function csChase(_obj){
	var _range = 1000;
	var _rangeWeight = 0;
	var resolution = 12;
	var _dist = 0; // distance
	var _dir = 0; // direction 
	var _map = 0; // new map to be added to the set
	var _uObj = 0; // unit vector of the object
	var _uMap = 0; // unit vector of context map
	// get interest values
	with(_obj)
	{
		_map = array_create(resolution, 0);
		_dist = point_distance(x,y,other.x,other.y);
		if(_dist > _range) continue;
		_rangeWeight = min(1,(1-(_dist/_range))/0.8); // weight = 1 when within 20% of max range
		_dir = point_direction(other.x,other.y,x,y);
		_uObj = speed_dir_to_vect2(1,_dir);
		for(var i=0;i<resolution;i++)
		{
			_uMap = speed_dir_to_vect2(1,i*(360 div resolution))
			_map[i] = _rangeWeight*vect_dot(_uMap,_uObj);
		}
		ds_list_add(other.global.interest_set, _map);
	}
}

function csAvoid(_obj){
	var _slow_radius = 30;
	var _mask_radius = 20;
	var _weight = 0;
	var _dist = 0; // distance
	var _dir = 0; // direction 
	var _map = 0; // new map to be added to the set
	var _uObj = 0; // unit vector of the object
	var _uMap = 0; // unit vector of context map
	// get interest values
	with(_obj)
	{
		if(other.id == id) continue;
		_map = array_create(resolution, 0);
		_dist = point_distance(x,y,other.x,other.y);
		if(_dist > _slow_radius) continue;
		// calculate danger values and add the resulting context map to the danger set
		_weight = 1-((_dist-_mask_radius)/(_slow_radius-_mask_radius)); // weight = 1 when within 30% of max range
		_dir = point_direction(other.x,other.y,x,y);
		_uObj = speed_dir_to_vect2(1,_dir);
		for(var i=0;i<resolution;i++)
		{
				_uMap = speed_dir_to_vect2(1,i*(360 div resolution));
				_map[i]	= _weight*vect_dot(_uMap,_uObj);			
				if(_dist > _mask_radius) && (_map[i] > 0) mask[i] = true;
		}
		ds_list_add(other.global.danger_set, _map);
	} 
}
//////////////////////////////////////////////////////////////
follower step event
/// @description 
var _lowest = 0;
var _map = undefined;
var _value = 0;
depth = -y;
allMasked = true;
speed_limit = global.speed;

// interpolate density at current position
myNode = global.gridSpace[# x div GRID_SIZE, y div GRID_SIZE];
if(ds_exists(path, ds_type_list)) && (ds_list_size(path) > 1) && (myNode == path[| 0]) 
{ 
	ds_list_delete(path, 0);
}

// clear context maps
for(var i=0;i<resolution;i++) 
{
	danger_map[i] = 0;
	interestMap[i] = 0;
	mask[i] = false;
}
ds_list_clear(global.interest_set);
ds_list_clear(global.danger_set);
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
	for(var i=0;i<ds_list_size(global.interest_set);i++)
	{
		_map = global.interest_set[| i];
		for(var j=0;j<resolution;j++)
		{
			if(_map[j] > interestMap[j]) interestMap[j] = _map[j];
		}
	}
	// combine danger set
	for(var i=0;i<ds_list_size(global.danger_set);i++)
	{
		_map = global.danger_set[| i];
		for(var j=0;j<resolution;j++){ if(_map[j] > danger_map[j]) danger_map[j] = min(1, _map[j]) }
	}
//--// merge danger and interest
	// find lowest danger value 
	for(var i=0;i<resolution;i++){ if(danger_map[i] < _lowest) _lowest = danger_map[i] }
	//// set the mask
	//for(var i=0;i<resolution;i++) { mask[i] = danger_map[i] > _lowest ? 1 : 0 }
	//// reduce all danger values by the lowest value
	//for(var i=0;i<resolution;i++){ danger_map[i] = danger_map[i] - _lowest }

	// get a preferred direction
	for(var i=0;i<resolution;i++) 
	{
		if(mask[i]) continue;
		_value = max(0, interestMap[i] - danger_map[i]);
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
velocity = vect_truncate(vect_add(velocity, steering), speed_limit*interest);
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
	moveWobble += moveWobbleSpeed*(vect_len(velocity) / speed_limit);
}
image_angle = 5*sin(moveWobble)


	what do i do once this pathfinding effectively simulating crowd movements, my plan be to begin work on Wizard tower, following the feature plan that I made prior.  in order to call this algorithm good, I still need the following:
	1. the move speed of followers needs to be dependant on the density around them when the density is above a certain threashold.  
	2. followers need to maintain a minimum distance from each other
	3. followers need to maintain a minimum distance from walls(tilemap) and structures(objects) 
	4. followers need to maintain a minimum distance from walls(tilemap) and structures(objects) 

*/
function sb_seek(x,y,weight){
	//return a vector for the steering direction to go towards given point
	var _target = vect2(argument[0],argument[1]);
	var _weight = argument[2];
	
	var _desired_velocity = vect_scaler(vect_subtract(_target,position_), sb_speed_);
	
	return vect_multr(vect_subtract(_desired_velocity,velocity_),_weight);
}
function sb_avoid(x,y,weight){
	//return a vector for the steering direction to avoid given point
	var _target = vect2(argument[0],argument[1]);
	var _weight = argument[2];
	
	var _desired_velocity = vect_scaler(vect_subtract(_target,position_), sb_speed_);
	
	return vect_multr(vect_subtract(_desired_velocity,velocity_),-_weight);
}
function sb_update()
{
	 // POSITION, COLLISIONS, & FACE UPDATE
	 var _cmd = ds_queue_head(command_queue);
	 var _dist = 0;
	 var _xgoal = _cmd[1];
	 var _ygoal = _cmd[2];
	// update position
	_dist = point_distance(x,y,_xgoal,_ygoal);
	if(_dist > sb_speed_)
	{
		// update velocity
		velocity_ = vect_truncate(vect_add(velocity_,steering_), sb_speed_);
	
	/*
		// predict a collision with the map_grid
		mp_collisions = mp_grid_place_meeting(self);
		if(!array_equals(mp_collisions,[0,0,0,0]))
		{
			// Right Collisions
			if(mp_collisions[0] && mp_collisions[2])
			{
				if(velocity_[1] > 0 ) velocity_[1] = 0;
			}
			// Left Collisions
			if(mp_collisions[1] && mp_collisions[3])
			{
				if(velocity_[1] < 0 ) velocity_[1] = 0;
			}
			// Top Collisions
			if(mp_collisions[0] && mp_collisions[1])
			{
				if(velocity_[2] < 0 ) velocity_[2] = 0;
			}
			// Bottom Collisions
			if(mp_collisions[2] && mp_collisions[3])
			{
				if(velocity_[2] > 0 ) velocity_[2] = 0;
			}
		}
	*/
		// update position
		position_ = vect_add(position_,velocity_);
		
		// set new location
		x = position_[1];
		y = position_[2];
			
	} else {
		// place unit at goal, then dequeue this action
		x = _xgoal;
		y = _ygoal;
		
		ds_queue_dequeue(command_queue);
	}
}
function sb_set_rules(goto_goal, avoid_units, avoid_buildings, avoid_enemies, follow_paths, no_stacking){
	// pass in booleans for each rule in the function to determine the 
	// behavior of the instance running this function
	var _r1 = argument[0];
	var _r2 = argument[1];
	var _r3 = argument[2];
	var _r4 = argument[3];
	var _r5 = argument[4];
	var _r6 = argument[5];
	var _cmd = ds_queue_head(command_queue);
	var i=0, _x1=0, _y1=0,_x2=0, _y2=0, _ind=0, _num=0, _weight = 0, _dir=0, _len=0,_dist=0;
	
	if(_r1) // RULE 1: goto goal
	{
		steering_ = vect_add(steering_, sb_seek(_cmd[1],_cmd[2],1));

		steering_ = vect_truncate(steering_, sb_force_);
	}
	
	if(_r2) // RULE 2: AVOID UNITS when moving at the same time
	{
		with(par_unit)
		{
			if(id != other.id)
			{
				if(state_ == MOVE)
				{
					_dist = point_distance(x,y,other.x,other.y);
					_weight = clamp(1 - _dist / personal_space_,0.05,0.4);
					if(_dist <= personal_space_)
					{
						with(other)
						{
							steering_ = vect_add(steering_, sb_avoid(other.x,other.y,_weight));

							steering_ = vect_truncate(steering_,sb_force_);
						}
					}
				}
			}
		}
	}
	
	if(_r3) // RULE 3: AVOID BUILDINGS when moving at the same time
	{
		with(par_building)
		{
			if(id != other.id)
			{
				if(state_ == MOVE)
				{
					_dist = point_distance(x,y,other.x,other.y);
					_weight = clamp(1 - _dist / personal_space_,0.05,0.4);
					if(_dist <= personal_space_)
					{
						with(other)
						{
							steering_ = vect_add(steering_, sb_avoid(other.x,other.y,_weight));

							steering_ = vect_truncate(steering_,sb_force_);
						}
					}
				}
			}
		}
	}
	
	if(_r4) // RULE 4: AVOID ENEMIES when moving at the same time
	{
		with(par_enemy)
		{
			if(id != other.id)
			{
				if(state_ == MOVE)
				{
					_dist = point_distance(x,y,other.x,other.y);
					_weight = clamp(1 - _dist / personal_space_,0.05,0.4);
					if(_dist <= personal_space_)
					{
						with(other)
						{
							steering_ = vect_add(steering_, sb_avoid(other.x,other.y,_weight));

							steering_ = vect_truncate(steering_,sb_force_);
						}
					}
				}
			}
		}
	}
	
	if(_r5) // RULE 5: follow paths
	{
		// create the path
		if(!path_exists(path_)) path_ = path_add(); 
		mp_grid_path_ext(global.map_grid, path_, x, y,_cmd[1],_cmd[2], true)
		// add target's final point if it exists
		if(target_ != noone)
		{
		if(instance_exists(target_))
		{
			path_add_point(path_get_number(path_),target_.x, target_.y,speed_);
		}
		}
		// find index of nearest point in the path
		_num = path_get_number(path_);
		_x1 = path_get_point_x(path_,0);
		_y1 = path_get_point_y(path_,0);
		for(i=1;i<_num;i++)
		{
			_x2 = path_get_point_x(path_,i);
			_y2 = path_get_point_y(path_,i);
			if(point_distance(x,y,_x2,_y2) <= point_distance(x,y,_x1,_y1))
			{
				_ind = i;
			}
		}
		// seek the next point in the path
		_x1 = path_get_point_x(path_,clamp(_ind+1,0,_num));
		_y1 = path_get_point_y(path_,clamp(_ind+1,0,_num));
		steering_ = vect_add(steering_, sb_seek(_x1,_y1,1));

		steering_ = vect_truncate(steering_,sb_force_);
	}

	if(_r6) // RULE 6: don't stack with instances that share a parent
	{
		var _parent = object_get_parent(object_index);
		var _inst = instance_place(x,y,object_index);
		if(_inst != noone)
		{
			// adjust the steering vector
			if(x == _inst.x && y == _inst.y)
			{ 
				_dir = irandom(359);				
				steering_ = vect_add(steering_, sb_avoid(lengthdir_x(sb_speed_,_dir),lengthdir_y(sb_speed_,_dir),1));
			} else { 
				steering_ = vect_add(steering_, sb_avoid(_inst.x,_inst.y,_weight));
			}
			// set steering vector
			steering_ = vect_truncate(steering_,sb_force_);
		}
	}
}