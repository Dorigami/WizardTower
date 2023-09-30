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
				
				// construct either a unit, or a structure
				if(_stats.entity_type == UNIT)
				{
					var _ent = ConstructUnit(owner.xx, owner.yy, owner.faction, owner.type_string);
					_ent.position[1] = owner.xTo;
					_ent.position[2] = owner.yTo;
					_ent.x = owner.xTo;
					_ent.y = owner.yTo;
				} else {
					ConstructStructure(owner.x, owner.y, owner.faction, owner.type_string);
				}
				ds_queue_enqueue(global.iEngine.killing_floor,owner);
			}
		//}
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
				if(attack_index == 0)
				{
					owner.move_penalty -= basic_attack.move_penalty;
				} else {
					owner.move_penalty -= active_attack.move_penalty;
				}
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
		attack_index = 0;
		attack_timer = ceil(basic_attack.duration*FRAME_RATE);
		basic_cooldown_timer = 100;
		basic_cooldown_rate = 100 / (basic_attack.cooldown*FRAME_RATE);
		
		owner.move_penalty += basic_attack.move_penalty;
		var _struct = {
			creator : owner.fighter,
			target : attack_target,
			attackData : basic_attack,
		}
		instance_create_layer(owner.position[1],owner.position[2],"Instances", basic_attack.damage_obj, _struct);
	}
	static UseActive = function(){
		attack_index = 1;
		attack_timer = ceil(active_attack.duration*FRAME_RATE);
		active_cooldown_timer = 100;
		active_cooldown_rate = active_attack.cooldown*FRAME_RATE*0.01;
		
		owner.move_penalty += active_attack.move_penalty;
		var _struct = {
			creator : owner.fighter,
			target : attack_target,
			attackData : active_attack,
		}
		instance_create_layer(owner.position[1],owner.position[2],"Instances", active_attack.damage_obj, _struct);
	}
    static DealDamage = function(_damage, _other_fighter){
		if(is_undefined(_other_fighter)) return false; //
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
		var i, j, _xx, _yy, _node, entity, list, index=0;
		var _cell_offset = max(1,range);
		var _limit = range <= 0 ? owner.collision_radius+HALF_GRID : range*GRID_SIZE;
		_xx = owner.xx;
		_yy = owner.yy;
		ds_list_clear(owner.checked_node_list);
		ds_list_clear(enemies_in_range);
		// loop through all nodes in range
		for(i=-_cell_offset; i<=_cell_offset; i++){
		for(j=-_cell_offset; j<=_cell_offset; j++){
			if(point_distance(_xx,_yy, _xx+i, _yy+j) <= _cell_offset+0.5) && (point_in_rectangle(_xx+i, _yy+j,0,0,global.game_grid_width-1,global.game_grid_height-1)){
				// get possible enemy
				_node = global.game_grid[# _xx+i, _yy+j];
				ds_list_add(owner.checked_node_list, _node);
				list = _node.occupied_list;
				if(ds_list_size(list) == 0) continue;
				for(var k=0; k<ds_list_size(list); k++)
				{
					index = 0;
					entity = list[| k];
					// see if it is a fighter and if it is an enemy faction
					if(owner.DistanceTo(entity) <= _limit) && (!is_undefined(entity.fighter)) && (entity.faction != owner.faction) && (ds_list_find_index(enemies_in_range, entity) == -1){
						// sort the new found entity base on distance from this fighter (does account for the size of the owner entity)
						while(!is_undefined(enemies_in_range[| index]))
						{
							if(owner.DistanceTo(enemies_in_range[| index]) > owner.DistanceTo(entity)){
								break;
							} else {
								index++;
							}
						}
						// insert enemy at index location
						ds_list_insert(enemies_in_range, index, entity);
					}
				}
			}
		}}
		if(ds_list_size(enemies_in_range) == 0)
		{
			return noone;
		} else {
			return enemies_in_range[| 0];
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
		CheckNodeChange(owner) 
	}
	static Animate = function(){
		var _totalFrames = image_number / 4;
		image_index = localFrame + (CARDINAL_DIR * _totalFrames);
		localFrame += sprite_get_speed(sprite_index) / FRAME_RATE;
	
		// if animation would loop on next game step
		if(localFrame >= _totalFrames)
		{
			animationEnd = true;
			localFrame -= _totalFrames
		} else {
			animationEnd = false;
		}
	}
	static Destroy = function(){

	}
}
Structure = function(_sup_bonus, _abilities, _rally_x, _rally_y) constructor{
	build_ticket = undefined;
	build_timer = -1;
	build_timer_set_point = -1;
    owner = undefined;
	supply_bonus = _sup_bonus;
	build_queue = ds_queue_create();
	blueprint_instance = noone;
	spawn_positions = [];
    abilities = _abilities;
	rally_x = _rally_x;
	rally_y = _rally_y;
	static Update = function(){
	    // check for node change
	    CheckNodeChange(owner);
		// handle build queue
		if(is_undefined(build_ticket)) && (ds_queue_size(build_queue) > 0)
		{
			// get the build ticket and set timer
			build_ticket = ds_queue_dequeue(build_queue)
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
		return _count;
	}
	static Destroy = function(){
		var _diff = 0;
		var _ind = 0;
		var _actor = global.iEngine.actor_list[| owner.faction];
		var _entity = undefined;
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

		    // clear id from occupy cells
		    if(size_check == 2){
				_ind = ds_list_find_index(global.game_grid[# xx, yy].occupied_list, id);
				if( _ind != -1) ds_list_delete(global.game_grid[# xx, yy].occupied_list, _ind);
				global.game_grid[# xx, yy].walkable = true;
		    } else {
				var _w = size[0];
				var _h = size[1];
				var _cw = _w div 2;
				var _ch = _h div 2;
				for(var i=-_cw; i<_w-_cw; i++){
				for(var j=-_ch; j<_h-_ch; j++){
					if(point_in_rectangle(xx+i, yy+j, 0, 0, global.game_grid_width-1, global.game_grid_height-1)) 
					{
						_ind = ds_list_find_index(global.game_grid[# xx+i, yy+j].occupied_list, id);
						if( _ind != -1) ds_list_delete(global.game_grid[# xx+i, yy+j].occupied_list, _ind);
						global.game_grid[# xx+i, yy+j].walkable = true;
					}
				}}
		    }
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

BasicUnitAI = function() constructor{
    commands = ds_list_create(); // a list containing all command structs
	owner = undefined;
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
		// if there is no command, check if entity is a fighter and get first enemy in range
		if(!is_undefined(owner.fighter)) && (!is_undefined(owner.fighter.basic_attack))
		{
			// resolve fighter behavior
			with(owner.fighter)
			{
				// attack the current attack target, if possible
				if(attack_target != noone) && (instance_exists(attack_target))
				{
					// target is valid if its occupying node is in range
					var _target_node = global.game_grid[# attack_target.xx, attack_target.yy];
					if(ds_list_find_index(owner.checked_node_list,_target_node) > -1) 
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
StructureTiedUnitAI = function() constructor{
    commands = ds_list_create(); // a list containing all command structs
	owner = undefined;
	static Update = function(){
		// unit cannot be commanded by the player, will attack at will and move to structure's rally point
		var _target = noone;

		// if there is no command, check if entity is a fighter and get first enemy in range
		if(!is_undefined(owner.fighter)) && (!is_undefined(owner.fighter.basic_attack))
		{
			// resolve fighter behavior
			with(owner.fighter)
			{
				// attack the current attack target, if possible
				if(attack_target != noone) && (instance_exists(attack_target))
				{
					// target is valid if its occupying node is in range
					var _target_node = global.game_grid[# attack_target.xx, attack_target.yy];
					if(ds_list_find_index(owner.checked_node_list,_target_node) > -1) 
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
		if(!is_undefined(owner.fighter)) && (!is_undefined(owner.fighter.basic_attack))
		{
			// resolve fighter behavior
			with(owner.fighter)
			{
				// attack the current attack target, if possible
				if(attack_target != noone) && (instance_exists(attack_target))
				{
					// target is valid if its occupying node is in range
					var _target_node = global.game_grid[# attack_target.xx, attack_target.yy];
					if(ds_list_find_index(owner.checked_node_list,_target_node) > -1) 
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
SpawningStructureAI = function() constructor{
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
				owner.structure.rally_x = _cmd.x;
				owner.structure.rally_y = _cmd.y;
			}
			if(command_timer > 0) && (--command_timer == 0){
			//	GetAction();
			//	if(is_undefined(command)) command_timer_set_point = -1;
			//}
		} 
		// if there is no command, check if entity is a fighter and get first enemy in range
		if(!is_undefined(owner.fighter)) && (!is_undefined(owner.fighter.basic_attack))
		{
			// resolve fighter behavior
			with(owner.fighter)
			{
				// attack the current attack target, if possible
				if(attack_target != noone) && (instance_exists(attack_target))
				{
					// target is valid if its occupying node is in range
					var _target_node = global.game_grid[# attack_target.xx, attack_target.yy];
					if(ds_list_find_index(owner.checked_node_list,_target_node) > -1) 
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