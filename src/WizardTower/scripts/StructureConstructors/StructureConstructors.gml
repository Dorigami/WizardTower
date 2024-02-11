function ConstructStructure(_x, _y, _faction, _type_string, _override_verify=false){
	show_debug_message("Constructing STRUCTURE: x = {0} | y = {1} | faction = {2} | string = {3}", _x, _y, _faction, _type_string);
	with(global.iEngine)
	{
		var _w, _h, _cw, _ch;
		var _structure = undefined, _blueprint_component = undefined, _fighter_component = undefined, _unit_component = undefined, _structure_component = undefined, _ai_component = undefined, _bunker_component = undefined, _interactable_component = undefined;
		var _struct = undefined;
		var _actor = actor_list[| _faction];
		var _stats = _actor.fighter_stats[$ _type_string];
		/*
		var _in_cell = point_in_rectangle(xx,yy,0,0,global.game_grid_width-1, global.game_grid_height-1)
		var _node = _in_cell ? global.game_grid[# xx, yy] : undefined;
		*/
		var _node = undefined;
		// get animations for the entity
		var _idle = asset_get_index("s_"+_type_string+"_idle");
		var _move = asset_get_index("s_"+_type_string+"_move");
		var _attack = asset_get_index("s_"+_type_string+"_attack");
		var _death = asset_get_index("s_"+_type_string+"_death");
		// get sound effects for entity
		_asset = asset_get_index("snd_"+_type_string+"_spawn");
		var _snd_spawn = _asset == -1 ? snd_structure_spawn_default : _asset;
		_asset = asset_get_index("snd_"+_type_string+"_move");
		var _snd_move = _asset == -1 ? snd_structure_move_defaukt : _asset;
		_asset = asset_get_index("snd_"+_type_string+"_attack");
		var _snd_attack = _asset == -1 ? snd_structure_attack_default : _asset;
		_asset = asset_get_index("snd_"+_type_string+"_death");
		var _snd_death = _asset == -1 ? snd_structure_death_default : _asset;
		
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
		
		// check arguments for validity
		if(is_undefined(_stats)) { show_debug_message("ERROR: construct structure - type string invalid"); exit;}
		if(is_undefined(_actor)) { show_debug_message("ERROR: construct structure - actor for faction {0} invalid", _faction); exit;}
		if(!_override_verify)&&(VerifyBuildingArea(_x, _y) == false) { show_debug_message("ERROR: construct structure - one or more of the nodes are occupied"); exit;}
		
		_fighter_component = new Fighter(_stats.hp, _stats.strength, _stats.defense, _stats.speed, _stats.range, _stats.tags, _stats.basic_attack, _stats.active_attack);
		_structure_component = new Structure(_stats.supply_capacity, _x,_y);
		if(_stats.bunker_size > 0) _bunker_component = new Bunker(_stats.bunker_size);
		
		switch(_type_string)
		{
			case "barricade":
				_ai_component = new BasicStructureAI();
				break;
			case "gunturret":
				_ai_component = new BasicStructureAI();
				break;
			case "sniperturret":
				_ai_component = new BasicStructureAI();
				break;
			case "barracks":  
				_ai_component = new BarracksAI();
				break;
			case "dronesilo":   
				_ai_component = new DroneSiloAI();
				break;
			case "flameturret": 
				_ai_component = new BasicStructureAI();
				break;
			case "mortarturret":  
				_ai_component = new MortarTurretAI();
				break;
			default:
				_ai_component = new BasicStructureAI();
			break;
		}
		
		// get the hex that this unit will spawn into
		with(global.i_hex_grid)
		{
			var _hex = pixel_to_hex(vect2(_x,_y));
			var _pos = hex_to_pixel(_hex, true);
			var _hex_index = hex_get_index(_hex);
			var _hex_list = is_undefined(_hex_index) ? undefined : hexarr_containers[_hex_index];
			// get a hex node that isn't it current node so that we can check for a node change
			var _node_change_check = hexarr_hexes[hexgrid_enabled_list[| 0]];
			if(is_undefined(_node_change_check)){ show_debug_message("there are no hex nodes to place the entity"); exit; }
			if(array_equals(_node_change_check, _hex)) { _node_change_check = hexarr_hexes[hexgrid_enabled_list[| 1]] } 
			if(is_undefined(_node_change_check)){ show_debug_message("there are no hex nodes to place the entity"); exit; }
		}
		
		// create the entity
		_struct = {
			// cell or tile position
			z : 0,
			xTo : _pos[1],
			yTo : _pos[2], 
			size : _stats.size,
			size_check : _stats.size[0]+_stats.size[1],
			
			// movement variables
			moveable : false,
			move_penalty : 0,
			collision_radius : _stats.collision_radius,
			vel_force_conservation : 0.95,
			vel_force : vect2(0,0),
			vel_movement : vect2(0,0),
			position : _pos,
			hex : _node_change_check, // the hex is not set so tha the node change function will trigger
			hex_prev : _hex,
			hex_path_list : ds_list_create(),
			
			// steering behavior
			member_of : noone,
			steering_behavior : -1,
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
			name : _stats.name,
			material_cost : _stats.material_cost,
			material_reward : _stats.material_reward,
			faction : _faction,
			engagement_radius : _stats.range,
			entity_type : _stats.entity_type,
			drone_destinations : _type_string == "drone" ? array_create(_stats.supply_capacity, noone) : undefined,
			abilities : _stats.abilities,

			// polymorphic components
			blueprint : _blueprint_component, 
			fighter : _fighter_component, 
			unit : _unit_component, 
			structure : _structure_component, 
			bunker : _bunker_component, 
			ai : _ai_component,
			interactable : _interactable_component,
		}

		_structure = instance_create_layer(_pos[1], _pos[2], "Instances", _stats.obj, _struct);

		// run node change for the new entity
		CheckNodeChange(_structure);

		// create particle effect on structure
		StructureSpawnPuffCreate(_pos[1], _pos[2])
		
		// set owner for each component
		if(!is_undefined(_bunker_component)) _bunker_component.owner = _structure;
		if(!is_undefined(_ai_component)) _ai_component.owner = _structure;
		if(!is_undefined(_fighter_component)) _fighter_component.owner = _structure;
		if(!is_undefined(_structure_component)) 
		{
			_structure_component.owner = _structure;
			// create an array of possible spawn locations
			var _arr_size = (_stats.size[0]+2)*(_stats.size[1]+2) - (_stats.size[0])*(_stats.size[1]);
			var _ind=0, _xxx=0, _yyy=0;
			_structure_component.spawn_positions = array_create(_arr_size, undefined);
		}

		// give structure to actor
		ds_list_add(_actor.structures, _structure);
		// set index with the actors structure list
		_structure.faction_list_index = _actor.structure_count++;
		
		return _structure; 
	}
}