/*
    possible tags: 
    unit_tags = {
        infantry : true,
        vehicle : true,
        flying : true,
        healer : true,
        builder : true,
        repair : true
    }
    structure_tags = {
        base :  true,
    }
*/

Blueprint = function(_build_time) constructor{
	owner = undefined;
	build_time = _build_time;
	build_timer_set_point = _build_time*FRAME_RATE;
	build_timer = -1;
	static Update = function(){
		if(++build_timer >= build_timer_set_point)
		{
			// replace blueprint with structure
			var _actor = global.iEngine.actor_list[| owner.faction];
			var _stats = _actor.fighter_stats[$ owner.type_string];
			_actor.supply_limit += _stats.supply_capacity;
			_actor.supply_in_queue -= _stats.supply_cost;
			_actor.supply_current += _stats.supply_cost;
			
			//remove from occupying hex node
			with(global.i_hex_grid)
			{
				var _container = hexarr_containers[hex_get_index(other.owner.hex)];
				ds_list_delete(_container, ds_list_find_index(_container, other.owner));
			}
			
			// construct either a unit, or a structure
			if(_stats.entity_type == UNIT)
			{
				ConstructUnit(owner.x, owner.y, owner.faction, owner.type_string);
			} else {
				ConstructStructure(owner.x, owner.y, owner.faction, owner.type_string);
			}
			ds_queue_enqueue(global.iEngine.killing_floor,owner);
		}
	}
	static Destroy = function(){
		//show_debug_message("Blueprint Entity has been destroyed.");
	}
}

Fighter = function(_hp, _strength, _defense, _speed, _range, _tags, _basic_attack=undefined, _active_attack=undefined) constructor{
    owner = undefined;
	hp = _hp;
    hp_max = _hp;
    strength = _strength;
	defense = _defense;
    speed = _speed;
    range = _range;
    tags = _tags;
	death_object = -1;
	enemies_in_range = ds_list_create();

	kill_count = 0;
	fight_behavior = -1;
	basic_attack = _basic_attack;
	active_attack = _active_attack;
	attack_target = noone; // this stores an instance id to help coordinate the fighting behavior with the steering behavior
    attack_index = -1; // this will either be 0 or 1, 0 for basic & 1 for active
	attack_timer = -1;
	retaliation_target = noone;
    basic_cooldown_timer  = 0   ; // set to 100 after any attack, the attack itself will affect the rate
    basic_cooldown_rate   = 0.01;
    active_cooldown_timer = 0   ; // set to 100 after any attack, the attack itself will affect the rate
    active_cooldown_rate  = 0.01;
    attack_move_penalty   = 0   ;
    
	static Update = function(){
		if(basic_cooldown_timer > 0) basic_cooldown_timer = max(0, basic_cooldown_timer - basic_cooldown_rate);
		if(active_cooldown_timer > 0) active_cooldown_timer = max(0, active_cooldown_timer - active_cooldown_rate);
		if(attack_index > -1)
		{
			if(--attack_timer == 0) 
			{
				attack_index = -1;
				// reset move penalty
				owner.attack_move_penalty = 0;
			}
		}
		if(basic_cooldown_timer > 0) && (--basic_cooldown_timer == 0) {
			// remove non existant instances from enemies in range
			var _size = ds_list_size(enemies_in_range);
			if(_size > 0){ for(var i=_size-1;i>=0;i--){ if(!instance_exists(enemies_in_range[| i])) ds_list_delete(enemies_in_range, i) } }
		}
		if(active_cooldown_timer > 0) && (--active_cooldown_timer == 0) {
			// remove non existant instances from enemies in range
			var _size = ds_list_size(enemies_in_range);
			if(_size > 0){ for(var i=_size-1;i>=0;i--){ if(!instance_exists(enemies_in_range[| i])) ds_list_delete(enemies_in_range, i) } }
		}
	}
	static UseBasic = function(){
		// this function needs to return the cooldown time(measured in steps) for enemy ai to function correctly
		// show_debug_message("UseBasic for object:{0} [1]", object_get_name(owner.object_index), owner.id);
		attack_index = 0;
		attack_timer = ceil(basic_attack.duration*FRAME_RATE);
		basic_cooldown_timer = 100;
		basic_cooldown_rate = 100 / (basic_attack.cooldown*FRAME_RATE);
		
		owner.attack_move_penalty = basic_attack.move_penalty;
		var _struct = {
			creator : owner.fighter,
			faction : owner.faction,
			target : attack_target,
			attackData : basic_attack,
		}
		instance_create_layer(owner.position[1], owner.position[2], "Instances", basic_attack.damage_obj, _struct);
		return basic_attack.cooldown*FRAME_RATE;
	}
	static UseActive = function(){
		// show_debug_message("UseActive for object:{0} [1]", object_get_name(owner.object_index), owner.id);
		attack_index = 1;
		attack_timer = ceil(active_attack.duration*FRAME_RATE);
		active_cooldown_timer = 100;
		active_cooldown_rate = active_attack.cooldown*FRAME_RATE*0.01;
		
		owner.attack_move_penalty = active_attack.move_penalty;
		var _struct = {
			creator : owner.fighter,
			faction : owner.faction,
			target : attack_target,
			attackData : active_attack,
		}
		instance_create_layer(owner.position[1],owner.position[2],"Instances", active_attack.damage_obj, _struct);
	}
    static DealDamage = function(_damage, _other_fighter){
		if(is_undefined(_other_fighter)) return false; 
		if(!instance_exists(_other_fighter.owner)) return false;
		if(!instance_exists(owner)) return false;
		if(_other_fighter.hp <= 0) return false; // fighter is already dead
		var _ent = _other_fighter.owner;
		var _damClac = max(1, _damage - _other_fighter.defense);
		// verify entity
		if(!instance_exists(_ent)) return false; // can't attack non-existance entity
		// run calculation
		_other_fighter.hp -= _damClac // 1 damage minimum is enforced here
		with(_other_fighter.owner)
		{
			CreateFloatNumber(position[1], 0.5*(position[2] + bbox_top), _damClac, FLOATTYPE.FLARE, 90);
		}
		if(_other_fighter.hp <= 0)
		{	
			// deal out rewards
			var _actor = global.iEngine.actor_list[| owner.faction];
			_actor.material += _other_fighter.owner.material_reward;
			// give a command to the HUD to animate increase in moeny
			with(oHUD)
			{
				var _cmd = new global.iEngine.Command("increase money",_other_fighter.owner.material_reward,_other_fighter.owner.x,_other_fighter.owner.y);
				ds_queue_enqueue(command_queue, _cmd);
			}
			
			// incrememnt kill count
			kill_count++;
			
			// create death effect if applicable
			if(object_exists(_ent.fighter.death_object)) instance_create_layer(_ent.xTo, _ent.yTo, "Instances", _ent.fighter.death_object);
			with(_other_fighter.owner){ if(sound_death != snd_empty) SoundCommand(sound_death, x, y) }
			ds_queue_enqueue(global.iEngine.killing_floor,_ent);
			return true; // fighter has been dealt a killing blow
		} else {
			// allow the other fighter to retaliate if they don't already have a retaliate target
			if(_other_fighter.retaliation_target == noone) || (ds_list_find_index(_other_fighter.enemies_in_range, _other_fighter.retaliation_target) == -1)
			{
				_other_fighter.retaliation_target = owner;
			}
		}
		return false; // fighter is still alive
	}
	static FindEnemies = function(){
		var i, j, _xx, _yy, _hex_count, _hex, _container, _hex_index, _entity;
		var _nodes_in_range = owner.nodes_in_range;
		var _nodes_in_range_count = array_length(_nodes_in_range);
		ds_list_clear(enemies_in_range);
		
		if(_nodes_in_range_count == 0)
		{
			return 0;
		} else {
			// loop through each hex node that is in range of the current entity
			for(i=0; i<_nodes_in_range_count; i++)
			{
				with(global.i_hex_grid)
				{
					_hex_index = hex_get_index(_nodes_in_range[i]);
					_container = global.i_hex_grid.hexarr_containers[_hex_index];
				}
				for(j=0;j<ds_list_size(_container);j++)
				{
					// get entity occupying the hex node
					_entity = _container[| j];
					// validate the entity as an enemy
					if(is_undefined(_entity)) || (!instance_exists(_entity)) || (_entity.faction == owner.faction) continue;
					// entity is valid as an enemy, add it to the list
					ds_list_add(enemies_in_range, _entity);
				}
			}
			return ds_list_size(enemies_in_range);
		}
	}
	static Destroy = function(){
		ds_list_destroy(enemies_in_range);
	}
}
Unit = function(_supply_cost, _can_bunker=true) constructor{
    owner = undefined;
    supply_cost = _supply_cost;
    can_bunker = _can_bunker;
	blueprint_instance = noone;
	static Update = function(){
		// check for node change
		CheckNodeChange(owner); 
	}
	static Animate = function(){
		var _totalFrames = image_number / 4;
		image_index = localFrame + (CARDINAL_DIR * _totalFrames);
		localFrame += sprite_get_speed(sprite_index) / FRAME_RATE;
	
		// if animation would loop on next game stepd	
		if(localFrame >= _totalFrames)
		{
			animationEnd = true;
			localFrame -= _totalFrames;
		} else {
			animationEnd = false;
		}
	}
	static Destroy = function(){
		// if unit is tied to a structure, remove it from structure's units list
		if(instance_exists(owner.creator))
		{
			var _list = owner.creator.structure.units;
			owner.creator.structure.supply_current--;
			ds_list_delete(_list, ds_list_find_index(_list, owner.id));
		}
	}
}
UnitEnemy = function(_supply_cost, _can_bunker=true) constructor{
    owner = undefined;
    supply_cost = _supply_cost;
    can_bunker = _can_bunker;
	blueprint_instance = noone;
	static Update = function(){
		// check for node change
		if(CheckNodeChange(owner))
		{
			// reset ai action timer if the new node has a valid target
			var _target = noone;
			switch(owner.object_index)	
			{
				case oGoliath:
					_target = goliath_get_target(owner);
					break;
				case oBuildingKiller:
					_target = buildingkiller_get_target(owner);
					break;
				case oUnitKiller:
					_target = unitkiller_get_target(owner);
					break;
				case oSwarmer:
					_target = swarmer_get_target(owner);
					break;
				default:
					_target = marcher_get_target(owner);
					break;
			}
			if(_target != noone) owner.ai.action_timer = 1;
		}
	}
	static Animate = function(){
		var _totalFrames = image_number / 4;
		image_index = localFrame + (CARDINAL_DIR*_totalFrames);
		localFrame += sprite_get_speed(sprite_index) / FRAME_RATE;
	
		// if animation would loop on next game stepd	
		if(localFrame >= _totalFrames)
		{
			animationEnd = true;
			localFrame -= _totalFrames;
		} else {
			animationEnd = false;
		}
	}
	static Destroy = function(){
		// if unit is tied to a structure, remove it from structure's units list
		if(instance_exists(owner.creator))
		{
			var _list = owner.creator.structure.units;
			owner.creator.structure.supply_current--;
			ds_list_delete(_list, ds_list_find_index(_list, owner.id));
		}
	}
}
Structure = function(_sup_cap, _rally_x, _rally_y) constructor{
	build_ticket = undefined;
	build_timer = -1;
	build_timer_set_point = -1;
    owner = undefined;
	units = ds_list_create();
	supply_current = 0;
	supply_capacity = _sup_cap;
	build_queue = ds_queue_create();
	blueprint_instance = noone;
	spawn_positions = [];
	rally_x = _rally_x;
	rally_y = _rally_y;
	static Update = function(){
	    // check for node change
	    if(CheckNodeChange(owner))
		{
			if(!global.iEngine.recalc_enemies_in_range) global.iEngine.recalc_enemies_in_range = true;
		}
		// handle build queue
		if(is_undefined(build_ticket)) && (ds_queue_size(build_queue) > 0)
		{
			// get the build ticket and set timer
			build_ticket = ds_queue_dequeue(build_queue);
			build_timer = build_ticket[1];
			build_timer_set_point = build_timer;
		}
		if(build_timer > 0)
		{
			if(--build_timer == 0)
			{
				// check for open spot to put the unit
				show_debug_message("number of open nodes = {0}", CheckSpawnLocations());
				if(CheckSpawnLocations() > 0) && (!is_undefined(build_ticket))
				{
					var _pos = spawn_positions;
					for(var i=0;i<array_length(_pos);i++)
					{
						/*
						var _node = global.game_grid[# _pos[i][0], _pos[i][1]];
						if(!is_undefined(_node)) && (instance_exists(_node.occupied_list))
						{
							with(global.iEngine)
							{
								// create a unit from the build ticket
								var _entity = ConstructUnit(_pos[i][0], _pos[i][1], other.owner.faction, other.build_ticket[0]);
								_entity.ai.command = {entity_comm_Amove : [other.rally_xx*GRID_SIZE, other.rally_yy*GRID_SIZE]}
								_entity.ai.command_timer = 1;
							}
							build_ticket = undefined;
							break;
						}
						*/
					}
				} else {
					// wait for a spot to open up near the structure
					build_timer = 10;
				} 
			}
		}
	}
	static CheckSpawnLocations = function(){
		var _count = 0;
		show_debug_message("spawn location size = "+ string(array_length(spawn_positions)))
		/*
		for(var i=0;i<array_length(spawn_positions);i++)
		{
			if(!is_undefined(spawn_positions[i]))
			{
				var _pos = spawn_positions[i];
				var _node = global.game_grid[# _pos[0], _pos[1]];
				if(!is_undefined(_node)) && (!instance_exists(_node.occupied_list)){
					_count++;
				}
			}
		}
		*/
		return _count;
	}
	static Destroy = function(){
		var _diff = 0;
		var _ind = 0;
		var _actor = global.iEngine.actor_list[| owner.faction];
		var _entity = undefined;
		if(!is_undefined(units)) && (ds_exists(units,ds_type_list)){ (ds_list_destroy(units)) }
		ds_queue_destroy(build_queue);
		with(owner)
		{
		    _diff = _actor.structure_count - faction_list_index;
		    if(_diff > 1){
		        for(var i=1; i<_diff; i++){
		            _entity = _actor.structures[| faction_list_index+i];
		            if(!is_undefined(_entity)) _entity.faction_list_index--;
		        }
		    }
		    ds_list_delete(_actor.structures, faction_list_index);
		    _actor.structure_count--;
		}
	}
}
Bunker = function(_capacity) constructor{
	owner = undefined;
	capacity = _capacity;
	unit_count = 0;
	units = ds_list_create();
	static Destroy = function(){
		ds_list_destroy(units);
	}
}

BasicEnemyAI = function() constructor{
    commands = ds_list_create(); // a list containing all command structs
	owner = undefined;
	action_timer = 20;
	static Update = function(){
		var _cmd = undefined;
		var _target = noone;
		if(ds_list_size(commands) > 0)
		{
			_cmd = commands[| 0];
			// handle movement
			if(!is_undefined(_cmd))
			{
				if(_cmd.type == "attack") _target = _cmd.value;
				if(instance_exists(_target))
				{
					if(owner.xTo != _cmd.value.position[1]) owner.xTo = _cmd.value.position[1];
					if(owner.yTo != _cmd.value.position[2]) owner.yTo = _cmd.value.position[2];
				} else {
					if(owner.xTo != _cmd.x) owner.xTo = _cmd.x;
					if(owner.yTo != _cmd.y) owner.yTo = _cmd.y;
				}
			}
		}
		//--// run actions at a limited time interval
		if(action_timer > -1)
		{
			if(--action_timer == 0)
			{
				// decide which node to go to 
				var _start_hex = owner.hex;
				var _goal_hex = hex_find_nearest_goal(_start_hex);
				if(is_undefined(_goal_hex)){ show_debug_message("ERROR: enemy ai component, no goal for enemy to move to"); action_timer = 5*FRAME_RATE; exit; }
				
				
				// find which direction points toward the goal node
				with(global.i_hex_grid)
				{
					var _desired_hex_index = hex_get_index(_start_hex);
					var _direction_index = point_direction(0,0,_goal_hex[1]-_start_hex[1], _goal_hex[2]-_start_hex[2]) div 60;
					var _hex_index = hexarr_neighbors[_desired_hex_index][_direction_index];
					if(other.MoveValidate(_hex_index))
					{
						// move to the most ideal neighbor
						_desired_hex_index = _hex_index;
					} else {
						// loop through neighbors, picking the first valid one found
						var _offset = 0;
						for(var i=1;i<4;i++)
						{
							// check clockwise neighbor
							_offset = _direction_index-i;
							if(_offset < 0) _offset += 6;
							_hex_index = hexarr_neighbors[_desired_hex_index][_offset];
							if(other.MoveValidate(_hex_index))
							{
								// this is a desireable neighbor
								_desired_hex_index = _hex_index;
								break;
							} 
							
							if(i == 3){// this means that none of the neighbors are valid
								_desired_hex_index = undefined;
								break;
							}
							
							// check counter-clockwise neighbor
							_offset = _direction_index+i;
							if(_offset > 5) _offset -= 6;
							_hex_index = hexarr_neighbors[_desired_hex_index][_offset]
							if(other.MoveValidate(_hex_index))
							{
								// this is a desireable neighbor
								_desired_hex_index = _hex_index;
								break;
							} 
						}
					}
				}

			//--// if owner has no 'path' to the goal, get one
				
			//--// reference the 'path' to get hte desired node 
				
			//--// if the node has a player structure attack it
				
			//--// if the node has a player unit attack it (targeting behavior changes based on the enemy type)
				// attack target if one exists, and exit loop if successful
				if(Attack()) exit;
				
			//--// if there are too many entities at the node, pick a different one
				
			//--// move to the desired node
				if(is_undefined(_desired_hex_index))
				{
					action_timer = 20;
					exit;
				} else {
					var _point = global.i_hex_grid.hexarr_positions[_desired_hex_index];
					Move(_point);
				}
			}
		}
	}
	static MoveValidate = function(_hex_index){
		// this will return true if the enemy can move there, will return false otherwise
		with(global.i_hex_grid)
		{
			if(is_undefined(_hex_index)) return false;
			if(ds_list_size(hexarr_containers[_hex_index]) >= 4)
			{
				show_debug_message("too many entities at location");
				return false;
			}
			return hexarr_enabled[_hex_index];
		}
	}
	static Move = function(_point){
		action_timer = 2*FRAME_RATE/owner.fighter.speed;
		owner.xTo = _point[1];
		owner.yTo = _point[2];
	}
	static GetAttackTarget = function(){
		var _target = noone;
		return _target;
	}
	static Attack = function(){
		// attack any enemy in range, but prioritize the attack command target
		with(owner.fighter) 
		{
			// attack valid target
			if(attack_index == -1) && (basic_cooldown_timer <= 0)
			{
				switch(owner.object_index)	
				{
					case oGoliath:
						goliath_get_target(owner);
						break;
					case oBuildingKiller:
						buildingkiller_get_target(owner);
						break;
					case oUnitKiller:
						unitkiller_get_target(owner);
						break;
					case oSwarmer:
						swarmer_get_target(owner);
						break;
					default:
						marcher_get_target(owner);
						break;
				}
				
				if(attack_target != noone)
				{
					// set attack direction for the entity
					owner.attack_direction = point_direction(owner.position[1], owner.position[2], attack_target.position[1], attack_target.position[2]);
					// set action timer for AI so the entity wont do anything during attack cooldown
					other.action_timer = UseBasic();
					// indicate that attack was successful
					return true;
				} else { return false; }
			} else {
				// indicate that attack failed
				return false;
			}
		} 
	}
	static Destroy = function(){
		// delete commands
		for(var i=0; i<ds_list_size(commands); i++)
		{
			if(!is_undefined(commands[| i])) delete commands[| i];
		}
		// destroy command list
		ds_list_destroy(commands);
	}
}
StructureTiedUnitAI = function() constructor{
    commands = ds_list_create(); // a list containing all command structs
	owner = undefined;
	static Update = function(){
		// unit cannot be commanded by the player, will attack at will and move to structure's rally point
		//var _cmd = commands[| 0];
		var _target = noone;
		//if(ds_list_size(commands) > 0)
		//{
		//	if(!is_undefined(_cmd))
		//	{
		//		ds_list_delete(commands, 0);
		//	}
		//} 
		// if there is no command, check if entity is a fighter and get first enemy in range
		if(!is_undefined(owner.fighter)) && (owner.fighter.basic_attack != -1)
		{
			// resolve fighter behavior
			with(owner.fighter)
			{
				// attack the current attack target, if possible
				if(attack_target != noone) && (instance_exists(attack_target))
				{
					// target is valid if its occupying node is in range
					var _target_node = noone;
					if(array_length(owner.nodes_in_range) > 0) 
					{
						_target = attack_target;
					} else {
						attack_target = noone;
					}
				} else {
					attack_target = noone;
				}
				// if there is no attack target, attack nearest enemy
				if(_target == noone)
				{
					_target = enemies_in_range[| 0];
					if(is_undefined(_target))
					{
						_target = noone;
					} else if(!instance_exists(_target)) {
						_target = noone;
						ds_list_delete(enemies_in_range, 0);
					}
				}
				
				// attack any enemy in range, but prioritize the attack command target
				if(_target != noone) 
				{
					// attack valid target
					if(attack_target != _target) attack_target = _target;
					if(attack_index == -1) && (basic_cooldown_timer <= 0)
					{
						owner.attack_direction = point_direction(owner.position[1], owner.position[2], _target.position[1], _target.position[2]);
						UseBasic();
					}
				} 
			}
		}
	}
	static Destroy = function(){
		// delete commands
		for(var i=0; i<ds_list_size(commands); i++)
		{
			if(!is_undefined(commands[| i])) delete commands[| i];
		}
		// destroy command list
		ds_list_destroy(commands);
	}
}
BasicStructureAI = function() constructor{
    commands = ds_list_create();
	owner = undefined;
	static Update = function(){
		var _cmd = undefined;
		var _target = noone;
		if(ds_list_size(commands) > 0)
		{
			//if(command_timer > 0) && (--command_timer == 0){
			//	GetAction();
			//	if(is_undefined(command)) command_timer_set_point = -1;
			//}
		} 
		// if there is no command, check if entity is a fighter and get first enemy in range
		if(!is_undefined(owner.fighter)) && (owner.fighter.basic_attack != -1)
		{
			// resolve fighter behavior
			with(owner.fighter)
			{
				// attack the current attack target, if possible
				if(attack_target != noone) && (instance_exists(attack_target))
				{
					// check if enemy is still in range
					if(ds_list_find_index(enemies_in_range, attack_target) == -1)
					{
						attack_target = noone;
					} else {
						_target = attack_target;
					}
				} else {
					attack_target = noone;
				}
				// if there is no attack target, attack nearest enemy
				if(_target == noone)
				{
					_target = enemies_in_range[| 0];
					if(is_undefined(_target))
					{
						_target = noone;
					} else if(!instance_exists(_target)) {
						_target = noone;
						ds_list_delete(enemies_in_range, 0);
					}
				}

				// attack any enemy in range, but prioritize the attack command target
				if(_target != noone) 
				{
					// attack valid target
					if(attack_target != _target) attack_target = _target;
					if(attack_index == -1) && (basic_cooldown_timer <= 0)
					{
						owner.attack_direction = point_direction(owner.position[1], owner.position[2], _target.position[1], _target.position[2]);
						UseBasic();
					}
				}
			}
		}
	}
	static Destroy = function(){
		// delete commands
		for(var i=0; i<ds_list_size(commands); i++)
		{ 
			if(!is_undefined(commands[| i])) delete commands[| i];
		}
		// destroy command list
		ds_list_destroy(commands);
	}
}
BarracksAI = function() constructor{
    commands = ds_list_create();
	owner = undefined;
	static Update = function(){
		var _cmd = undefined;
		var _target = noone;
		if(ds_list_size(commands) > 0)
		{
			_cmd = commands[| 0];
			if(!is_undefined(_cmd))
			{
				ds_list_delete(commands, 0);
				// set rally point
				with(global.i_hex_grid)
				{
					var _nodes = other.owner.nodes_in_range;
					show_debug_message("NODES: {0}", _nodes);
					var _shortest_dist = 1000;
					var _shortest_hex = undefined;
					var _hex_in_range = vect2(0,0);
					var _target_hex = pixel_to_hex(vect2(_cmd.x,_cmd.y));
					var _dist = 0;
					for(var i=0;i<array_length(_nodes);i++)
					{
						_dist = point_distance(_nodes[i][1], _nodes[i][2], _target_hex[1], _target_hex[2]);
						if(_dist <= _shortest_dist)
						{
							// set this hex as the closest to the target hex node
							_shortest_dist = _dist;
							_shortest_hex = _nodes[i];
						}
					}
					if(is_undefined(_shortest_hex)){ show_debug_message("shortest hex was undefined for some reason"); exit;}
					var _hex_pos =  hex_to_pixel(_shortest_hex, true);
				}

				with(owner.structure)
				{
					rally_x = _hex_pos[1];
					rally_y = _hex_pos[2];
					// give move command to the units controlled by this structure
					for(var i=ds_list_size(units); i>0; i--)
					{
						var _inst = units[| i-1];
						if(instance_exists(_inst))
						{
							_inst.xTo = rally_x;
							_inst.yTo = rally_y;
						}
					}
				}
			}
		} 
		// if there is no command, check if entity is a fighter and get first enemy in range
		if(!is_undefined(owner.fighter)) && (!is_undefined(owner.fighter.basic_attack))
		{
			// resolve fighter behavior
			with(owner.fighter)
			{	
				// activate attack to spawn a unit
				if(attack_index == -1) && (basic_cooldown_timer <= 0) && (ds_list_size(owner.structure.units) < owner.structure.supply_capacity)
				{
					owner.attack_direction = point_direction(owner.position[1], owner.position[2], owner.structure.rally_x, owner.structure.rally_y);
					UseBasic();
				}
			}
		}
	}
	static Destroy = function(){
		// delete commands
		for(var i=0; i<ds_list_size(commands); i++)
		{
			if(!is_undefined(commands[| i])) delete commands[| i];
		}
		// destroy command list
		ds_list_destroy(commands);
	}
}
MortarTurretAI = function() constructor{
    commands = ds_list_create();
	owner = undefined;
	static Update = function(){
		var _cmd = undefined;
		var _target = noone;
		if(ds_list_size(commands) > 0)
		{
			_cmd = commands[| 0];
			if(!is_undefined(_cmd))
			{
				ds_list_delete(commands, 0);
				// set rally point
				var _limit = owner.fighter.range*GRID_SIZE;
				var _len = point_distance(owner.position[1], owner.position[2], _cmd.x, _cmd.y)
				if(_len > _limit)
				{
					var _dir = point_direction(owner.position[1], owner.position[2], _cmd.x, _cmd.y);
					owner.structure.rally_x = owner.position[1] + lengthdir_x(_limit,_dir);
					owner.structure.rally_y = owner.position[2] + lengthdir_y(_limit, _dir);
				} else {
					owner.structure.rally_x = _cmd.x;
					owner.structure.rally_y = _cmd.y;
				}
			}
		} 
		// if there is no command, check if entity is a fighter and get first enemy in range
		if(!is_undefined(owner.fighter)) && (owner.fighter.basic_attack != -1)
		{
			// resolve fighter behavior
			with(owner.fighter)
			{	
				// activate attack to spawn a unit
				if(attack_index == -1) && (basic_cooldown_timer <= 0)
				{
					owner.attack_direction = point_direction(owner.position[1], owner.position[2], owner.structure.rally_x, owner.structure.rally_y);
					UseBasic();
				}
			}
		}
	}
	static Destroy = function(){
		// delete commands
		for(var i=0; i<ds_list_size(commands); i++)
		{
			if(!is_undefined(commands[| i])) delete commands[| i];
		}
		// destroy command list
		ds_list_destroy(commands);
	}
}
DroneSiloAI = function() constructor{
    commands = ds_list_create();
	owner = undefined;
	static Update = function(){
		var _cmd = undefined;
		var _target = noone;
		if(ds_list_size(commands) > 0)
		{
			_cmd = commands[| 0];
			if(!is_undefined(_cmd))
			{
				ds_list_delete(commands, 0);
				// set rally point
				with(global.i_hex_grid)
				{
					var _nodes = other.owner.nodes_in_range;
					show_debug_message("NODES: {0}", _nodes);
					var _shortest_dist = 1000;
					var _shortest_hex = undefined;
					var _hex_in_range = vect2(0,0);
					var _target_hex = pixel_to_hex(vect2(_cmd.x,_cmd.y));
					var _dist = 0;
					for(var i=0;i<array_length(_nodes);i++)
					{
						_dist = point_distance(_nodes[i][1], _nodes[i][2], _target_hex[1], _target_hex[2]);
						if(_dist <= _shortest_dist)
						{
							// set this hex as the closest to the target hex node
							_shortest_dist = _dist;
							_shortest_hex = _nodes[i];
						}
					}
					if(is_undefined(_shortest_hex)){ show_debug_message("shortest hex was undefined for some reason"); exit;}
					var _hex_pos =  hex_to_pixel(_shortest_hex, true);
				}

				with(owner.structure)
				{
					rally_x = _hex_pos[1];
					rally_y = _hex_pos[2];
					// give move command to the units controlled by this structure
					for(var i=ds_list_size(units); i>0; i--)
					{
						var _inst = units[| i-1];
						if(instance_exists(_inst))
						{
							_inst.xTo = rally_x;
							_inst.yTo = rally_y;
						}
					}
				}
			}
		} 
		
		// if there is no command, check if entity is a fighter and get first enemy in range
		if(!is_undefined(owner.fighter)) && (owner.fighter.basic_attack != -1)
		{
			// resolve fighter behavior
			with(owner.fighter)
			{	
				// activate attack to spawn a unit
				if(attack_index == -1) && (basic_cooldown_timer <= 0) && (ds_list_size(owner.structure.units) < owner.structure.supply_capacity)
				{
					owner.attack_direction = point_direction(owner.position[1], owner.position[2], owner.structure.rally_x, owner.structure.rally_y);
					UseBasic();
				}
			}
		}
	}
	static Destroy = function(){
		// delete commands
		for(var i=0; i<ds_list_size(commands); i++)
		{
			if(!is_undefined(commands[| i])) delete commands[| i];
		}
		// destroy command list
		ds_list_destroy(commands);
	}
}