function SB_pathlover(_goal_priority, _attack_priority, _density_priority, _discomfort_priority){
	// this function is assumed to be run inside of a unit entity
	// will update current node as position changes
	var i=0,j=0,k=0,v=0,interest=-100000000000,dist=0,ang=0,uAng=vect2(0,0),uVel=vect2(0,0);
	var speed_limit = fighter.speed*max(0, 1-attack_move_penalty-external_move_penalty); // move penalty represents debuffs that affect movement speed
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
					global.game_grid_bbox[0], 
					global.game_grid_bbox[0] + global.game_grid_width*GRID_SIZE - 1);
    position[2] = clamp(
					position[2] + vel_force[2] + vel_movement[2], 
					global.game_grid_bbox[1], 
					global.game_grid_bbox[1] + global.game_grid_height*GRID_SIZE - 1);
	x = position[1];
	y = position[2];
	
	for(i=0;i<ds_list_size(_col_list);i++)
	{
		EnforceMinDistance(_col_list[| i]);
	}
	
	EnforceTileCollision();
	
	ds_list_destroy(_col_list);
	
	// complete route
	if(position[1] <= global.game_grid_bbox[0]+1)
	{
		HurtPlayer();
		instance_destroy();
	}
}

function SB_Marine(_goal_priority, _attack_priority, _density_priority, _discomfort_priority){
	// this function is assumed to be run inside of a unit entity
	// will update current node as position changes

	var _col_list = ds_list_create();
	with(global.i_hex_grid)
	{	// copy the container for the current hex node in order to check collisions later
		var _hex_index = hex_get_index(other.hex); 
		if(!is_undefined(_hex_index)){ ds_list_copy(_col_list, hexarr_containers[_hex_index]) }
	}
	
	// track onto goal position
	position[1] += 0.12*(xTo-position[1]);
	position[2] += 0.12*(yTo-position[2]);

	// collide with all entities within the same node
	for(var i=0;i<ds_list_size(_col_list);i++)
	{
		EnforceMinDistance(_col_list[| i]);
	}

	// update position
	x = position[1];
	y = position[2];
	
	ds_list_destroy(_col_list);
}
function SB_Drone(_goal_priority, _attack_priority, _density_priority, _discomfort_priority){
	// this function is assumed to be run inside of a unit entity
	// will update current node as position changes
	
	if(position[1] == xTo) && (position[2] == yTo) exit;
	
	// animate floating
	if(float_enabled)
	{
		float_wave += float_wave_speed;
		float_mod += 0.06*(1-float_mod);
		z = float_mod*(float_height) + float_osc*sin(float_wave);
		//show_debug_message("osc = {0}",float_osc*sin(float_wave))
	}
	
	// this function is assumed to be run inside of a unit entity
	// will update current node as position changes

	var _col_list = ds_list_create();
	with(global.i_hex_grid)
	{	// copy the container for the current hex node in order to check collisions later
		var _hex_index = hex_get_index(other.hex); 
		if(!is_undefined(_hex_index)){ ds_list_copy(_col_list, hexarr_containers[_hex_index]) }
	}
	
	// track onto goal position
	position[1] += 0.12*(xTo-position[1]);
	position[2] += 0.12*(yTo-position[2]);

	// collide with all entities within the same node
	for(var i=0;i<ds_list_size(_col_list);i++)
	{
		EnforceMinDistance(_col_list[| i], true);
	}

	// update position
	x = position[1];
	y = position[2];

	// EnforceTileCollisiosn(True)
	ds_list_destroy(_col_list);
}

function SB_hex_enemy(_goal_priority, _attack_priority, _density_priority, _discomfort_priority){
	// this function is assumed to be run inside of a unit entity
	// will update current node as position changes

	var _col_list = ds_list_create();
	with(global.i_hex_grid)
	{	// copy the container for the current hex node in order to check collisions later
		var _hex_index = hex_get_index(other.hex); 
		if(!is_undefined(_hex_index)){ ds_list_copy(_col_list, hexarr_containers[_hex_index]) }
	}
	
	// track onto goal position
	position[1] += 0.12*(xTo-position[1]);
	position[2] += 0.12*(yTo-position[2]);

	// collide with all entities within the same node
	for(var i=0;i<ds_list_size(_col_list);i++)
	{
		EnforceMinDistance(_col_list[| i]);
	}

	// update position
	x = position[1];
	y = position[2];
	
	ds_list_destroy(_col_list);
}

function SB_PlayerUnit(_goal_priority, _attack_priority, _density_priority, _discomfort_priority){
	// this function is assumed to be run inside of a unit entity
	// will update current node as position changes

	if(position[1] == xTo) && (position[2] == yTo) exit;

	var _col_list = ds_list_create();
	with(global.i_hex_grid)
	{	// copy the container for the current hex node in order to check collisions later
		var _hex_index = hex_get_index(other.hex); 
		if(!is_undefined(_hex_index)){ ds_list_copy(_col_list, hexarr_containers[_hex_index]) }
	}
	
	// track onto goal position
	position[1] += 0.12*(xTo-position[1]);
	position[2] += 0.12*(yTo-position[2]);

	// update position
	x = position[1];
	y = position[2];

	// collide with all entities within the same node
	for(var i=0;i<ds_list_size(_col_list);i++)
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
		var _new_hex = undefined;
		var _new_index = undefined;
		var _new_list = undefined;
		var _old_hex = undefined;
		var _old_index = undefined;
		var _old_list = undefined;
		
		with(global.i_hex_grid)
		{
			_new_hex = pixel_to_hex(other.position);
			_new_index = hex_get_index(_new_hex);
		}
		
		// leave script unless the node location has changed
		if(is_undefined(_new_index)) || (array_equals(_new_hex, hex)) return false;
	
		// get necessary data
		with(global.i_hex_grid)
		{
			_old_hex = other.hex;
			_old_index = hex_get_index(_old_hex);
			_old_list = hexarr_containers[_old_index];
			_new_list = hexarr_containers[_new_index];
		}
		
		//add to new list
		ds_list_add(_new_list, id)
		//remove from old list
		ds_list_delete(_old_list, ds_list_find_index(_old_list, id));
		
		// update hex references
		hex_prev = _old_hex;
		hex = _new_hex;
		
		// run fighter update (get index numbers for all hex nodes in range)
		if(!is_undefined(fighter))
		{
			with(global.i_hex_grid)
			{
				// get hexes in range
				other.nodes_in_range = hex_in_radius(other.hex, other.fighter.range);
			}
		}
		// indicate that the hex node has changed, in order to recalc enemies for fighters
		with(global.iEngine){ 
			if(!recalc_enemies_in_range) recalc_enemies_in_range = true; 
		}
		return true;
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

