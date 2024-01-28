function ConstructBlueprint(_x, _y, _faction, _type_string){
	with(global.iEngine)
	{
		var _w, _h, _cw, _ch;
		var _blueprint = undefined, _blueprint_component = undefined, _fighter_component = undefined, _unit_component = undefined, _structure_component = undefined, _ai_component = undefined, _bunker_component = undefined, _interactable_component = undefined;
		var _struct = undefined;
		var _actor = actor_list[| _faction];
		var _stats = _actor.fighter_stats[$ _type_string];
		var _node = undefined; // global.game_grid[# clamp(_x div GRID_SIZE,0,global.game_grid_width-1), clamp(_y div GRID_SIZE,0,global.game_grid_height-1)];
		var _idle = -1;
		var _move = -1; 
		var _attack = -1;
		var _death = -1;
	
		// check arguments for validity
		if(is_undefined(_stats)) { show_debug_message("ERROR: construct blueprint - type string invalid"); exit;}
		if(is_undefined(_actor)) { show_debug_message("ERROR: construct blueprint - actor for faction {0} invalid", _faction); exit;}
		if(VerifyBuildingArea(_x, _y, true) == false) { show_debug_message("ERROR: construct blueprint - one or more of the nodes are occupied"); exit;}

		// create blueprint component
		_blueprint_component = new Blueprint(_stats.build_time);
		_fighter_component = new Fighter(2, 0, 0, 0, 0, _stats, -1, -1);

		// get the hex that this unit will spawn into
		with(global.i_hex_grid)
		{
			var _hex = pixel_to_hex(vect2(_x,_y));
			var _pos = hex_to_pixel(_hex);
			var _hex_index = hex_get_index(_hex);
			var _hex_list = is_undefined(_hex_index) ? undefined : hexarr_containers[_hex_index];
		}

		// create the entity
		_struct = {
			sprite_index : asset_get_index("s_"+_type_string+"_idle"),
			z : 0,
			xTo : _x,
			yTo : _y,
			size : _stats.size,
			size_check : _stats.size[0]+_stats.size[1],
			faction : _faction,
			type_string : _type_string,
			blueprint : _blueprint_component,
			fighter : _fighter_component,
			unit : _unit_component,
			structure : _structure_component,
			bunker : _bunker_component,
			ai : _ai_component,
			interactable : _interactable_component,
			name : _stats.name,
			collision_radius : _stats.collision_radius,
			material_reward : 0,
			
			//sound
			sound_spawn : snd_empty,
			sound_move : snd_empty,
			sound_attack : snd_empty,
			sound_death : snd_empty,
			
			// position data
			moveable : false,
			member_of : noone,
			steering_behavior : BlueprintSteering,
			vel_force : vect2(0,0),
			vel_movement : vect2(0,0),
			position : vect2(_x, _y),
			hex : _hex,
			hex_prev : _hex,
			hex_path_list : ds_list_create(),
			
			//animation
			spr_idle : _idle,
			spr_move : _move,
			spr_attack : _attack,
			spr_death : _death,
		}

		_blueprint = instance_create_layer(_x, _y, "Instances", _stats.obj, _struct);
		_blueprint.image_alpha = 0.3;
		// set component owner
		if(!is_undefined(_blueprint_component)) _blueprint_component.owner = _blueprint;
		if(!is_undefined(_fighter_component)) _fighter_component.owner = _blueprint;
		// give structure to actor
		ds_list_add(_actor.blueprints, _blueprint);
		// set index with the actors structure list
		_blueprint.faction_list_index = _actor.blueprint_count++;
		// have entity occupy the node that it is spawning on
		if(!is_undefined(_hex_list)) ds_list_add(_hex_list, _blueprint);
		
		return _blueprint;
	}
}
