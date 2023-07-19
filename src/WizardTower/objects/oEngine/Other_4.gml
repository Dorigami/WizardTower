/// @description 

// set new edge boundary
// east boundary
var edge = boundary_edges[EAST];
edge.x1 = room_width; edge.y1 = 0; 
edge.x2 = room_width; edge.y2 = room_height;
// north boundary
edge = boundary_edges[NORTH];
edge.x1 = 0; edge.y1 = 0; 
edge.x2 = room_width; edge.y2 = 0;
// west boundary
edge = boundary_edges[WEST];
edge.x1 = 0; edge.y1 = 0; 
edge.x2 = 0; edge.y2 = room_height;
// south boundary
edge = boundary_edges[SOUTH];
edge.x1 = 0; edge.y1 = room_height; 
edge.x2 = room_width; edge.y2 = room_height;



if(room != rStartMenu) && (room != rInit)
{
	room_start_init_game_grid();

	room_start_init_camera();

	// RoomStartInitMap();
	
	// RoomStartInitEntities();

	
	// init ai for existing actors
	for(var i=0; i<ds_list_size(actor_list); i++)
	{
		var _actor = actor_list[| i];
		if(!is_undefined(_actor.ai))
		{
			show_debug_message("initializing AI for actor " + string(i))
			_actor.ai.Init();
		}
	}
	
	//// create the enemy actor
	//var _ai_component = new DebugActorAI();
	//var enemy_actor = new Actor(false, ds_list_size(actor_list), 20, _ai_component);  // 'true' means that this actor is a player
	//_ai_component.owner = enemy_actor;
	// _player=false, _index, _apm=0, _ai=undefined
	//ds_list_add(actor_list, enemy_actor);
	
	//// give the enemy a base
	//ConstructStructure(50, 15, enemy_actor.faction, "base");

}

// add tilemap to the room
if(global.terrain_tiles == -1) || (!layer_tilemap_exists(temp_layer, global.terrain_tiles)){
	temp_layer = layer_create(100);
	global.terrain_tiles = layer_tilemap_create(temp_layer, 0, 0, tsCheckerTile, global.game_grid_width*GRID_SIZE, global.game_grid_height*GRID_SIZE);
}
