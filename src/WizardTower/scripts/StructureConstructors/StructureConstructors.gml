function ConstructStructure(_x, _y, _faction, _type_string){
	// show_debug_message("Constructing STRUCTURE: xx = {0} | yy = {1} | faction = {2} | string = {3}", _xx, _yy, _faction, _type_string);
	with(global.iEngine)
	{
		var _w, _h, _cw, _ch;
		var _xx = (_x - global.game_grid_xorigin) div GRID_SIZE;
		var _yy = (_y - global.game_grid_yorigin) div GRID_SIZE;
		var _structure = undefined, _blueprint_component = undefined, _fighter_component = undefined, _unit_component = undefined, _structure_component = undefined, _ai_component = undefined, _bunker_component = undefined, _interactable_component = undefined;
		var _struct = undefined;
		var _actor = actor_list[| _faction];
		var _stats = _actor.fighter_stats[$ _type_string];
		/*
		var _in_cell = point_in_rectangle(xx,yy,0,0,global.game_grid_width-1, global.game_grid_height-1)
		var _node = _in_cell ? global.game_grid[# xx, yy] : undefined;
		*/
		var _node = global.game_grid[# _xx, _yy];
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
		
		// check arguments for validity
		if(is_undefined(_stats)) { show_debug_message("ERROR: construct structure - type string invalid"); exit;}
		if(is_undefined(_actor)) { show_debug_message("ERROR: construct structure - actor for faction {0} invalid", _faction); exit;}
		if(VerifyBuildingArea(_x, _y, _stats.size[0], _stats.size[1]) == false) { show_debug_message("ERROR: construct structure - one or more of the nodes are occupied"); exit;}
		
		_fighter_component = new Fighter(_stats.hp, _stats.strength, _stats.defense, _stats.speed, _stats.range, _stats.tags, _stats.basic_attack, _stats.active_attack);
		_structure_component = new Structure(_stats.supply_capacity, 
						clamp(_x+lengthdir_x(_stats.collision_radius,270),global.game_grid_xorigin,global.game_grid_xorigin+global.game_grid_width*GRID_SIZE), 
						clamp(_y+lengthdir_y(_stats.collision_radius,270),global.game_grid_yorigin,global.game_grid_yorigin+global.game_grid_height*GRID_SIZE));
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
				_ai_component = new BasicStructureAI();
				break;
			default:
				_ai_component = new BasicStructureAI();
			break;
		}

		// create the entity
		_struct = {
			// cell or tile position
			z : 0,
			xx : _xx, 
			yy : _yy,
			xx_prev : _xx,
			yy_prev : _yy,
			xTo : _x,
			yTo : _y, 
			size : _stats.size,
			size_check : _stats.size[0]+_stats.size[1],
			
			// movement variables
			moveable : false,
			move_penalty : 0,
			collision_radius : _stats.collision_radius,
			vel_force_conservation : 0.95,
			vel_force : vect2(0,0),
			vel_movement : vect2(0,0),
			position : vect2(_x, _y),
			
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
			material_cost : _stats.material_cost,
			material_reward : _stats.material_reward,
			faction : _faction,
			engagement_radius : _stats.range,
			entity_type : _stats.entity_type,

			// polymorphic components
			blueprint : _blueprint_component, 
			fighter : _fighter_component, 
			unit : _unit_component, 
			structure : _structure_component, 
			bunker : _bunker_component, 
			ai : _ai_component,
			interactable : _interactable_component,
		}

		_structure = instance_create_layer(_x, _y, "Instances", _stats.obj, _struct);
		with(_structure)
		{
			position[1] += ((bbox_right - bbox_left) div 2) - sprite_get_xoffset(sprite_index);
			position[2] += ((bbox_bottom - bbox_top) div 2) - sprite_get_yoffset(sprite_index);
		}
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
			_w = _stats.size[0]+2;
			_h = _stats.size[1]+2;
			_cw = _w div 2;
			_ch = _h div 2;
			if(_structure_component.supply_capacity > 0)
			{
				_structure_component.units = ds_list_create();
			}
			for(var i=-_cw; i<_w-_cw; i++){
			for(var j=-_ch; j<_h-_ch; j++){
				// make sure we are looking at an edge position
				if(i == -_cw) || (i == _w-_cw) || (j == -_ch) || (j == _h-_ch)
				{
					_xxx = _xx+i;
					_yyy = _yy+j;
					if(point_in_rectangle(_xxx, _yyy, 0, 0, global.game_grid_width-1, global.game_grid_height-1))
					{ 
						_node = global.game_grid[# _xxx, _yyy];
						if(!is_undefined(_node.occupied_list)) continue; 
						_structure_component.spawn_positions[_ind] = [_xxx, _yyy];
					}
					_ind++;
				}
			}}
		}

		// give structure to actor
		ds_list_add(_actor.structures, _structure);
		// set index with the actors structure list
		_structure.faction_list_index = _actor.structure_count++;
		// have structure occupy applicable nodes
		_w = _stats.size[0];
		_h = _stats.size[1];
		_cw = _w div 2;
		_ch = _h div 2;
		for(var i=-_cw; i<_w-_cw; i++){
		for(var j=-_ch; j<_h-_ch; j++){
			if(point_in_rectangle(_xx+i,_yy+j,0,0,global.game_grid_width,global.game_grid_height))
			{
				ds_list_add(global.game_grid[# _xx+i, _yy+j].occupied_list, _structure);
				global.game_grid[# _xx+i, _yy+j].walkable = false;
				global.game_grid[# _xx+i, _yy+j].block_sight = true;
			}
		}}
		
		return _structure; 
	}
}