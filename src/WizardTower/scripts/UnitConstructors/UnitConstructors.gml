function ConstructUnit(_x, _y, _faction, _type_string){
	show_debug_message("Constructing UNIT: xx = {0} | yy = {1} | faction = {2} | string = {3}", _x, _y, _faction, _type_string);
	with(global.iEngine)
	{
		var _unit = undefined, _steering_preference = undefined, _blueprint_component = undefined, _fighter_component = undefined, _unit_component = undefined, _structure_component = undefined, _ai_component = undefined, _bunker_component = undefined, _interactable_component = undefined;
		var _struct = undefined, _asset = -1;
		var _actor = actor_list[| _faction];
		var _stats = _actor.fighter_stats[$ _type_string];
		var _in_cell = point_in_rectangle(_x div GRID_SIZE, _y div GRID_SIZE,0,0,global.game_grid_width-1, global.game_grid_height-1)
		var _node = _in_cell ? global.game_grid[# _x div GRID_SIZE, _y div GRID_SIZE] : undefined;
		
		// get animations for the entity
		var _idle = asset_get_index("s_"+_type_string+"_idle");
		var _move = asset_get_index("s_"+_type_string+"_move");
		var _attack = asset_get_index("s_"+_type_string+"_attack");
		var _death = asset_get_index("s_"+_type_string+"_death");
		
		// get sound effects for entity
		_asset = asset_get_index("snd_"+_type_string+"_spawn");
		var _snd_spawn = _asset == -1 ? snd_empty : _asset;
		_asset = asset_get_index("snd_"+_type_string+"_move");
		var _snd_move = _asset == -1 ? snd_empty : _asset;
		_asset = asset_get_index("snd_"+_type_string+"_attack");
		var _snd_attack = _asset == -1 ? snd_empty : _asset;
		_asset = asset_get_index("snd_"+_type_string+"_death");
		var _snd_death = _asset == -1 ? snd_empty : _asset;
		
		// check if animations were found
		if(_idle == -1) || (_move == -1) || (_attack == -1) || (_death == -1){
			show_message("animation sprites not set correctly:"
			+"\ntype string = "+_type_string
			+"\nidle = "+string(_idle)
			+"\nmove = "+string(_move)
			+"\nattack = "+string(_attack)
			+"\ndeath = "+string(_death)
			);
			game_end();
		}
		
		// check the arguments for validity
		if(is_undefined(_stats)) { show_debug_message("ERROR: construct unit - type string invalid"); exit;}
		// if(ds_list_size(_node.occupied_list) > 0) { show_debug_message("ERROR: construct unit - node is occupied"); exit;}
		if(is_undefined(_actor)) { show_debug_message("ERROR: construct unit - actor for faction {0} invalid", _faction); exit;}
		// if(_actor.supply_current + _actor.supply_in_queue + _stats.supply_cost > _actor.supply_limit) { show_debug_message("ERROR: construct unit - supply limit reached"); exit;}

		// create components
		if(_stats.bunker_size > 0) _bunker_component = new Bunker(_stats.bunker_size);
		_fighter_component = new Fighter(_stats.hp, _stats.strength, _stats.defense, _stats.speed, _stats.range, _stats.tags, _stats.basic_attack,_stats.active_attack);
		_unit_component = new Unit(_stats.supply_cost, true); // the last argument sets "can_bunker"

		// get animations and ai components
		_ai_component = new BasicUnitAI();
		_steering_preference = UnitSteering_Basic;
		switch(_type_string)
		{
			case "summoner":
				break;
			case "drone":
				_steering_preference = SB_Drone;
				delete _ai_component; _ai_component = new StructureTiedUnitAI();
				break;
			case "marine":
				_steering_preference = SB_Marine;
				delete _ai_component; _ai_component = new StructureTiedUnitAI();
				break;
			case "marcher":
				_steering_preference = SB_Horizontal;
				break;
			case "swarmer":
				_steering_preference = SB_Horizontal;
				break;
			case "buildingkiller":
				_steering_preference = SB_Horizontal;
				break;
			case "unitkiller":
				_steering_preference = SB_Horizontal;
				break;
			case "goliath":
				_steering_preference = SB_Horizontal;
				break;
			case "skeleton":
				_steering_preference = SB_Horizontal;
				break;
		}

		// allow unit to be controlled by the player if it belongs to the player
		if(_faction == PLAYER_FACTION) _steering_preference = SB_PlayerUnit;

		// create the entity
		_struct = {
			// cell or tile position
			xx : _x div GRID_SIZE, 
			yy : _y div GRID_SIZE,
			my_node : _node,
			xx_prev : _x div GRID_SIZE,
			yy_prev : _y div GRID_SIZE,
			my_node_prev : _node,
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
			steering_mag : 0.3,
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
			sprite_index : _idle,
			spr_idle : _idle,
			spr_move : _move,
			spr_attack : _attack,
			spr_death : _death,
			
			//sound
			sound_spawn : _snd_spawn,
			sound_move : _snd_move,
			sound_attack : _snd_attack,
			sound_death : _snd_death,
			
			// misc variables 
			material_cost : _stats.material_cost,
			material_reward : _stats.material_reward,
			faction : _faction,  
			engagement_radius : _stats.range,
			entity_type : _stats.entity_type,
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