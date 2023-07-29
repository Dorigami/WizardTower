function ConstructBlueprint(_x, _y, _faction, _type_string){
	with(global.iEngine)
	{
		_x = clamp((_x div GRID_SIZE)*GRID_SIZE,global.game_grid_xorigin,global.game_grid_xorigin+global.game_grid_width*GRID_SIZE-1);
		_y = clamp((_y div GRID_SIZE)*GRID_SIZE,global.game_grid_yorigin,global.game_grid_yorigin+global.game_grid_height*GRID_SIZE-1);
		var _xx = _x div GRID_SIZE;
		var _yy = _y div GRID_SIZE;
		var _w, _h, _cw, _ch;
		var _blueprint = undefined, _blueprint_component = undefined, _fighter_component = undefined, _unit_component = undefined, _structure_component = undefined, _ai_component = undefined, _bunker_component = undefined, _interactable_component = undefined;
		var _struct = undefined;
		var _actor = actor_list[| _faction];
		var _stats = _actor.fighter_stats[$ _type_string];
		var _node = global.game_grid[# clamp(_x div GRID_SIZE,0,global.game_grid_width-1), clamp(_y div GRID_SIZE,0,global.game_grid_height-1)];
		var _idle = -1;
		var _move = -1; 
		var _attack = -1;
		var _death = -1;
		
		// check arguments for validity
		if(is_undefined(_stats)) { show_debug_message("ERROR: construct blueprint - type string invalid"); exit;}
		if(is_undefined(_actor)) { show_debug_message("ERROR: construct blueprint - actor for faction {0} invalid", _faction); exit;}
		if(VerifyBuildingArea(_x, _y, _stats.size[0], _stats.size[1]) == false) { show_debug_message("ERROR: construct blueprint - one or more of the nodes are occupied"); exit;}

		// create blueprint component
		_blueprint_component = new Blueprint(_stats.build_time);

		// create the entity
		_struct = {
			xx : _xx,
			yy : _yy,
			xx_prev : _xx,
			yy_prev : _yy,
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
			
			// position data
			moveable : false,
			member_of : noone,
			steering_behavior : BlueprintSteering,
			vel_force : vect2(0,0),
			vel_movement : vect2(0,0),
			position : vect2(_x, _y),

			
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
		// give structure to actor
		ds_list_add(_actor.blueprints, _blueprint);
		// set index with the actors structure list
		_blueprint.faction_list_index = _actor.blueprint_count++;
		// have structure occupy applicable nodes
		_w = _stats.size[0];
		_h = _stats.size[1];
		_cw = _w div 2;
		_ch = _h div 2;
		for(var i=-_cw; i<_w-_cw; i++){
		for(var j=-_ch; j<_h-_ch; j++){
			if(point_in_rectangle(_xx+i,_yy+j,0,0,global.game_grid_width,global.game_grid_height))
			{
				global.game_grid[# _xx+i, _yy+j].occupied_blueprint = _blueprint;
			}
		}}
		
		return _blueprint;
	}
}
