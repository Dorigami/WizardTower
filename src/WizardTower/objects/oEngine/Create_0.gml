/// @description initialize game

/*
    add 8-directional cost values to the game grid for enemies
    add a 'path value' to the game grid.  enemy mobs will steer toward nodes with high path value
    add a method to cover areas of the game grid with fog_of_war (create oShroud object for the map editor)
    add steering behavior for enemy mobs
    create an instance layer on top of the fog_of_war layer, for a particle system object to display effects

    need tilemap 'PathInit' that can indicate spawn locations
*/

color0 = make_colour_rgb(13,43,69);
color1 = make_colour_rgb(32,60,86);
color2 = make_colour_rgb(84,78,104);
color3 = make_colour_rgb(141,105,122);
color4 = make_colour_rgb(208,129,89);
color5 = make_colour_rgb(255,170,94);
color6 = make_colour_rgb(255,212,163);
color7 = make_colour_rgb(255,236,214);

available_abilities_arr = ["-1","-1","-1","-1","-1","-1","-1","-1","-1"];
ability_hotkeys = ["1","2","3","4","5","6","7","8","9"];
keybinds_string = "escape - pause/unpause/cancel action\n" 
                + "F3 - toggle debug view\n"
                + "alt+Enter - toggle fullscreen\n"
                + "[ - spawn a base\n"
                + "] - spawn a ranger\n"
                + "left mouse - select entities\n"
                + "right mouse - command entities (move / attack)\n"
                + "ctrl+right mouse - A move command\n"
                + " - use ability 1 ["+ability_hotkeys[0]+"]  |  2 ["+ability_hotkeys[1]+"]  |  3 ["+ability_hotkeys[2]+"]\n"
                + "                       4 ["+ability_hotkeys[3]+"]  |  5 ["+ability_hotkeys[4]+"]  |  6 ["+ability_hotkeys[5]+"]\n"
                + "                       7 ["+ability_hotkeys[6]+"]  |  8 ["+ability_hotkeys[7]+"]  |  9 ["+ability_hotkeys[8]+"]\n"

MACROS();
DEFAULTSTATS();
STRUCTS();
ActorAI();
COMPONENTS();
randomize();
game_set_speed(FRAME_RATE, gamespeed_fps);
InitializeDisplay(ASPECT_RATIO);
// initialize game grid
global.game_grid_xorigin = 0;
global.game_grid_yorigin = 0;
global.game_grid_width = 10;
global.game_grid_height = 10;
global.game_grid = ds_grid_create(global.game_grid_width, global.game_grid_height);
for(var i=0; i<global.game_grid_width;  i++){
for(var j=0; j<global.game_grid_height; j++){
    var _node = new Node(i,j);
    global.game_grid[# i, j] = _node;
}}
// other global variables
global.unitSelection = ds_list_create();
global.iEngine = id;
global.iHUD = instance_create_layer(0,0,"Instances", oHUD);
global.iCamera = instance_create_layer(0, 0, "Instances", oCamera);
global.iSelect = instance_create_layer(0, 0, "Instances", oSelect);
global.iSound = instance_create_layer(0, 0, "Instances", oSound);
global.game_state = GameStates.PLAY;
global.game_state_previous = global.game_state;
global.mouse_focus = noone;
global.hud_focus = noone;
global.danger_set = ds_list_create();
global.interest_set = ds_list_create();
cs_unit_vectors = array_create(CS_RESOLUTION, 0);
action = {};
mouse_action = {};
hud_action = {};
menu_stack = ds_stack_create();
blueprint_instance = noone;
killing_floor = ds_queue_create();
game_grid_heap = new NodeHeap();
game_grid_heap.Initialize(global.game_grid);
initial_player_abilities = array_create(9, undefined);
current_player_abilities = array_create(9,undefined);
zoom_delay_time = 10;

// fill the unit vector array with unit vectors for each context steering directions
for(var i=0; i<CS_RESOLUTION; i++){
    cs_unit_vectors[i] = speed_dir_to_vect2(1, i*(360 div CS_RESOLUTION));
}

actor_list = ds_list_create();

// add actors
player_actor = new Actor(true, PLAYER_FACTION);  // 'true' means that this actor is a player
enemy_actor = new Actor(false, ENEMY_FACTION);  // 'false' means that this actor is not a player
neutral_actor = new Actor(false, NEUTRAL_FACTION);  // 'false' means that this actor is not a player
ds_list_add(actor_list, neutral_actor, player_actor, enemy_actor);



window_set_fullscreen(false);
room_goto(ROOM_START);

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
			case 0: _type = "buy_turret"; break; 
			case 1: _type = "buy_barricade"; break; 
			case 2: _type = "buy_sentry"; break; 
			case 3: _type = ""; break; 
			case 4: _type = ""; break; 
			case 5: _type = ""; break; 
			case 6: _type = ""; break; 
			case 7: _type = ""; break; 
			case 8: _type = ""; break; 
		}
		// create abilites and add them to initial and stored ability arrays
		initial_player_abilities[i] = new Ability(_type);
		current_player_abilities[i] = variable_clone(initial_player_abilities[i]);
	}
}
/* 

function RoomStartInitEntities(){
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
		
		switch(type_string)
		{
			case "shieldbearer":
				ConstructUnit((x-global.game_grid_xorigin) div GRID_SIZE, (y-global.game_grid_yorigin) div GRID_SIZE, faction, type_string);
				break;
			case "spearbearer":
				ConstructUnit((x-global.game_grid_xorigin) div GRID_SIZE, (y-global.game_grid_yorigin) div GRID_SIZE, faction, type_string);
				break;
			case "lensbearer":
				ConstructUnit((x-global.game_grid_xorigin) div GRID_SIZE, (y-global.game_grid_yorigin) div GRID_SIZE, faction, type_string);
				break;
			case "torchbearer":
				ConstructUnit((x-global.game_grid_xorigin) div GRID_SIZE, (y-global.game_grid_yorigin) div GRID_SIZE, faction, type_string);
				break;
			case "base":
				ConstructStructure((x-global.game_grid_xorigin) div GRID_SIZE, (y-global.game_grid_yorigin) div GRID_SIZE, faction, type_string);
				break;
		}
		instance_destroy();
	}
}

function RoomStartInitMap(){
    // initalize the map by setting sight lines, blocking nodes, setting location & size of the game grid, etc...
	var _layer = layer_get_id("MapInit");
	var _w=0, _h=0, i=0, j=0,_node=undefined;
    var x1=room_width, x2=0, y1=room_height, y2=0;
    global.game_grid_xorigin = undefined;
    global.game_grid_yorigin = undefined;
	if(layer_exists(_layer)) && (layer_tilemap_exists(_layer, layer_tilemap_get_id(_layer)))
	{
        //loop through all tiles, indicating the bounds of the level by checking which tiles are marked
		var _ts = layer_tilemap_get_id(_layer);

        for(i=0; i<tilemap_get_width(_ts); i++){
		for(j=0; j<tilemap_get_height(_ts); j++){
			if(tilemap_get(_ts, i, j) > 0) 
            {
                if(x1 > i) x1 = i;
                if(x2 < i) x2 = i;
                if(y1 > j) y1 = j;
                if(y2 < j) y2 = j;
            } else { continue }
		}}

        _w = x2-x1+1;
        _h = y2-y1+1;
		
        // check for valid width & height
        if(_w <= 0) || (_h <= 0)
        {
			show_message("the MapInit tileset has no data.  Room cannot initialize [" + room_get_name(room) + "]"); 
			game_end();
		}
		
		// adjust the game grid if needed
		ds_grid_resize(global.game_grid, _w, _h);
        global.game_grid_xorigin = x1*GRID_SIZE;
        global.game_grid_yorigin = y1*GRID_SIZE;
		global.game_grid_width = _w;
		global.game_grid_height = _h;
		
		// adjust size of the density maps
		for(i=0;i<ds_list_size(faction_entity_density_maps);i++)
		{
			ds_grid_resize(faction_entity_density_maps[| i], _w, _h);
		}

		// initialize the node heap
		game_grid_heap.Initialize(global.game_grid);
		
		for(i=0; i<_w; i++){
		for(j=0; j<_h; j++){
			_node = global.game_grid[# i, j]; 
			if(!is_instanceof(_node, Node))
			{
				global.game_grid[# i, j] = new Node(i, j);
			} else {
                //update center position of the node
                _node.x = global.game_grid_xorigin + (i*GRID_SIZE + (GRID_SIZE div 2));
	            _node.y = global.game_grid_yorigin + (j*GRID_SIZE + (GRID_SIZE div 2));
            }
		}}
		
		// set blocked & block sight variables for each node
		for(i=0; i<_w; i++){
		for(j=0; j<_h; j++){
			_node = global.game_grid[# i, j];
			_node.blocked = tilemap_get(_ts, i+x1, j+y1) == 1 || tilemap_get(_ts, i+x1, j+y1) == 3;
			_node.block_sight = tilemap_get(_ts, i+x1, j+y1) == 2 || tilemap_get(_ts, i+x1, j+y1) == 3;
		}}
		// update existing actors
		for(var i=0;i<ds_list_size(actor_list);i++)
		{
			var _actor = actor_list[| i];
			ds_grid_resize(_actor.fov_map, global.game_grid_width, global.game_grid_height);
			ds_grid_clear(_actor.fov_map, VISION.UNSEEN);
			ds_grid_resize(_actor.build_map, global.game_grid_width, global.game_grid_height);
			ds_grid_clear(_actor.build_map, 0);
		}
        // destroy the map init stuff
        layer_tilemap_destroy(_ts);
        layer_destroy(_layer);
        // initialize the fog of war if unit vision is disabled
        if(global.fog_of_war == -1) || (!layer_tilemap_exists(fog_of_war_layer, global.fog_of_war)){
            fog_of_war_layer = layer_create(-2000);
            global.fog_of_war = layer_tilemap_create(fog_of_war_layer, 0, 0, tsFovFog, global.game_grid_width*GRID_SIZE, global.game_grid_height*GRID_SIZE);
        }
        if(!fog_of_war_enabled)
        {
            // set tiles of fog_of_war tileset, containing the game grid, to visable
			for(i=0; i<tilemap_get_width(global.fog_of_war); i++){
            for(j=0; j<tilemap_get_height(global.fog_of_war); j++){
				if(i>=x1) && (i <= x2) && (j >= y1) && (j <= y2)
				{
					tilemap_set(global.fog_of_war, VISION.SIGHTED, i, j);
				} else {
					tilemap_set(global.fog_of_war, VISION.UNSEEN, i, j);
				}
			}}
        }
	} else {
		show_debug_message("Can't init the map grid, layer doesn't exist\nlayer id = {0}\ntilemap id = {1}", layer_exists(_layer), layer_tilemap_exists(_layer, layer_tilemap_get_id(_layer)));
	}
}

