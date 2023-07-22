function ConstructUnit(_x, _y, _faction, _type_string){
	show_debug_message("Constructing UNIT: xx = {0} | yy = {1} | faction = {2} | string = {3}", _x, _y, _faction, _type_string);
	with(global.iEngine)
	{
		var _unit = undefined, _steering_preference = undefined, _blueprint_component = undefined, _fighter_component = undefined, _unit_component = undefined, _structure_component = undefined, _ai_component = undefined, _bunker_component = undefined, _interactable_component = undefined;
		var _struct = undefined;
		var _actor = actor_list[| _faction];
		var _stats = _actor.fighter_stats[$ _type_string];
		var _node = global.game_grid[# _x div GRID_SIZE, _y div GRID_SIZE];
		var _idle = -1;
		var _move = -1; 
		var _attack = -1;
		var _death = -1;
		
		// check the arguments for validity
		if(is_undefined(_stats)) { show_debug_message("ERROR: construct unit - type string invalid"); exit;}
		// if(ds_list_size(_node.occupied_list) > 0) { show_debug_message("ERROR: construct unit - node is occupied"); exit;}
		if(is_undefined(_actor)) { show_debug_message("ERROR: construct unit - actor for faction {0} invalid", _faction); exit;}
		// if(_actor.supply_current + _actor.supply_in_queue + _stats.supply_cost > _actor.supply_limit) { show_debug_message("ERROR: construct unit - supply limit reached"); exit;}

		// create components
		if(_stats.bunker_size > 0) _bunker_component = new Bunker(_stats.bunker_size);
		_fighter_component = new Fighter(_stats.hp, _stats.strength, _stats.defense, _stats.speed, _stats.range, _stats.tags, _stats.basic_attack,_stats.active_attack);
		_unit_component = new Unit(_stats.supply_cost, _stats.abilities, true); // the last argument sets "can_bunker"

		// get animations and ai components 
		switch(_type_string)
		{
			default:
				_ai_component = new BasicUnitAI();
				_steering_preference = UnitSteering_Basic;
			case "shieldbearer":
				_idle = sShieldIdle;
				_move = sShieldMove; 
				_attack = sShieldShoot;
				_death = sShieldDeath;
				break;
			case "spearbearer":
				_idle = sSpearIdle;
				_move = sSpearMove; 
				_attack = sSpearShoot;
				_death = sSpearDeath;
				break;
			case "lensbearer":
				_idle = sLensIdle;
				_move = sLensMove; 
				_attack = sLensShoot;
				_death = sLensDeath;
				break;
			case "torchbearer":
				_idle = sTorchIdle;
				_move = sTorchMove; 
				_attack = sTorchShoot;
				_death = sTorchDeath;
				break;
			case "skeleton":
				_idle = sSkeletonIdle;
				_move = sSkeletonMove; 
				_attack = sSkeletonAttack;
				_death = sSkeletonDeath;

				_ai_component = new BasicUnitAI();
				_steering_preference = SB_Horizontal;
				break;
		}

		// create the entity
		_struct = {
			// cell or tile position
			xx : _x div GRID_SIZE, 
			yy : _y div GRID_SIZE,
			xx_prev : _x div GRID_SIZE,
			yy_prev : _y div GRID_SIZE,
			xTo : _x,
			yTo : _y, 
			xAnchor : _x,
			yAnchor : _y, 
			size : _stats.size,
			size_check : _stats.size[0]+_stats.size[1],
			
			// movement variables
			moveable : true,
			move_penalty : 0,
			collision_radius : round(0.2*GRID_SIZE),
			steering_mag : 0.2,
			vel_force_conservation : 0.95,
			vel_force : vect2(0,0),
			vel_movement : vect2(0,0),
			steering : vect2(0,0),
			position : vect2(_x, _y),
			
			// steering behavior
			member_of : noone,
			steering_behavior : _steering_preference,
			danger_map : array_create(CS_RESOLUTION, 0), // 8-directional movement avoidance
			interest_map : array_create(CS_RESOLUTION, 0), // 8-directional movement preference
			mask : array_create(CS_RESOLUTION, 0), // 8-directional movement prevention
			all_masked : false,
			interest : 0,
			
			//animation
			spr_idle : _idle,
			spr_move : _move,
			spr_attack : _attack,
			spr_death : _death,
			
			// misc variables 
			material_reward : _stats.material_reward,
	        experience_reward : _stats.experience_reward,
			upgrade_reward : _stats.upgrade_reward,
			faction : _faction,  
			los_radius : _stats.los_radius,
			los_polygon : ds_list_create(),
			los_tiles : ds_list_create(), // a list of all offset coordinates for tiles within line of sight
			engagement_radius : _stats.range,
			build_radius : _stats.build_radius,
			attack_direction : 0,

			// polymorphic components
			blueprint : _blueprint_component, 
			fighter : _fighter_component, 
			unit : _unit_component, 
			structure : _structure_component, 
			bunker : _bunker_component, 
			ai : _ai_component,
			interactable : _interactable_component
		}

		_unit = instance_create_layer(_x, _y, "Instances", _stats.obj, _struct);

		// set owner for each component
		if(!is_undefined(_bunker_component)) _bunker_component.owner = _unit;
		if(!is_undefined(_fighter_component)) _fighter_component.owner = _unit;
		if(!is_undefined(_unit_component)) _unit_component.owner = _unit;
		if(!is_undefined(_ai_component)) _ai_component.owner = _unit;

		// add entity to actor's list
		ds_list_add(_actor.units, _unit);
		// set index with the actors structure list
		_unit.faction_list_index = _actor.unit_count++;
		// have entity occupy the node that it is spawning on
		if(!is_undefined(_node)) ds_list_add(_node.occupied_list, _unit);

		return _unit;
	}
}