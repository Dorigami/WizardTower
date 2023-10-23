function room_start_init_game_grid(){
	var _w=0, _h=0, i=0, j=0,_node=undefined;
    var x1=room_width, x2=0, y1=room_height, y2=0;
    global.game_grid_xorigin = undefined;
    global.game_grid_yorigin = undefined;
	with(oPlaySpace)
	{
		x1 = bbox_left div GRID_SIZE;
		x2 = bbox_right div GRID_SIZE;
		y1 = bbox_top div GRID_SIZE;
		y2 = bbox_bottom div GRID_SIZE;
		instance_destroy();
	}
	_w = x2-x1+1;
	_h = y2-y1+1;
	
	// check for valid width & height
	if(_w <= 0) || (_h <= 0)
	{
		show_message("playspace not set correctly.  please check the playspace object in the following room: [" + room_get_name(room) + "]"); 
		game_end();
	}
	
	// adjust the game grid if needed
	ds_grid_resize(global.game_grid, _w, _h);
	global.game_grid_xorigin = x1*GRID_SIZE;
	global.game_grid_yorigin = y1*GRID_SIZE;
	global.game_grid_width = _w;
	global.game_grid_height = _h;

	show_debug_message("game grid param origin: [{0}, {1}] | dimensions: [{2}, {3}]", 
		global.game_grid_xorigin, 
		global.game_grid_yorigin,
		global.game_grid_width,
		global.game_grid_height
		);
	// fill game grid with nodes	
	for(i=0; i<_w; i++){
	for(j=0; j<_h; j++){
		_node = global.game_grid[# i, j]; 
		if(!is_instanceof(_node, Node))
		{
			global.game_grid[# i, j] = new Node(i, j);
		} else {
			_node.walkable = true;
			ds_list_clear(_node.occupied_list);
			//update center position of the node
			_node.x = global.game_grid_xorigin + (i*GRID_SIZE + (GRID_SIZE div 2));
			_node.y = global.game_grid_yorigin + (j*GRID_SIZE + (GRID_SIZE div 2));
		}
	}}

	// initialize the node heap
	game_grid_heap.Initialize(global.game_grid);
	
	// update existing actors
	for(var i=0;i<ds_list_size(actor_list);i++)
	{
		var _actor = actor_list[| i];
		// ds_grid_resize(_actor.fov_map, global.game_grid_width, global.game_grid_height);
		// ds_grid_resize(_actor.build_map, global.game_grid_width, global.game_grid_height);
		// ds_grid_clear(_actor.build_map, 0);
	}
}

function room_start_init_camera(){
	// set camera position 
	// NOTE: the game grid must initialize prior to updating the camera

	var _x = global.game_grid_xorigin + GRID_SIZE*global.game_grid_width div 2;
	var _y = global.game_grid_yorigin + GRID_SIZE*global.game_grid_height div 2;

	with(global.iCamera)
	{
		cam = view_camera[0];

		with(global.iEngine)
		{
			camera_set_view_size(other.cam,idealWidth*view_zoom, idealHeight*view_zoom);
		}

		follow = noone;
		viewWidthHalf = round(0.5*camera_get_view_width(cam));
		viewHeightHalf = round(0.5*camera_get_view_height(cam));


		x = _x; y = _y;
		xTo = x; yTo = y;
	}
}
function room_start_init_player_stats(){
	with(player_actor)
	{
		supply_limit = 40;
		material = 200;
		experience_points = 0;
		upgrade_points = 0;
		health = 20;
		ds_list_clear(blueprints);
		ds_list_clear(units);
		ds_list_clear(structures);
		ds_list_clear(control_groups);
	}
}
function room_start_init_abilities(){
	var _type = "";
	var _ability = undefined;
	for(var i=0;i<9;i++)
	{
		switch(i)
		{
			case 0: _type = "barricade"; break; 
			case 1: _type = "gunturret"; break; 
			case 2: _type = "sniperturret"; break; 
			case 3: _type = "barracks"; break; 
			case 4: _type = "dronesilo"; break; 
			case 5: _type = "flameturret"; break; 
			case 6: _type = "mortarturret"; break; 
			case 7: _type = "toggle_info"; break; 
			case 8: _type = "sell_towers"; break; 
		}
		// create abilites and add them to initial and stored ability arrays
		initial_player_abilities[i] = new Ability(_type);
		current_player_abilities[i] = variable_clone(initial_player_abilities[i]);
	}
}


function room_start_init_entities(){
	with(pEntity)
	{
		show_debug_message("type is: {0}, faction is: {1}, position is: [{2}] [{3}]", type_string, faction, x, y)
		if(faction != PLAYER_FACTION)
		{
			//check for an actor, add it to the actor list if needed
			var _actor = other.actor_list[| faction];
			var _ai_component = undefined;
			if(is_undefined(_actor)) || (!is_instanceof(_actor, other.Actor))
			{
				// create the enemy actor
				_actor = new other.Actor(false, faction, 20, _ai_component);  // 'true' means that this actor is a player
				ds_list_insert(other.actor_list, faction, _actor);
			}
			// set ai for the new actor
			if(type_string == "base") 
			{
				_ai_component = actor_ai; // this ai component is set in the creation code of the entity in its room
				_ai_component.owner = _actor;
			}
			_actor.ai = _ai_component;
		}
		var _fighterstats = global.iEngine.actor_list[| faction].fighter_stats;
		_fighterstats = _fighterstats[$ type_string];
		if(_fighterstats.entity_type == UNIT)
		{
			ConstructUnit(x, y, faction, type_string);
		} else if(_fighterstats.entity_type == STRUCTURE){
			ConstructStructure(x, y, faction, type_string);
		}
		instance_destroy();
	}
}

