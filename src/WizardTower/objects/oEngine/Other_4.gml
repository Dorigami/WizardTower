/// @description 

/*
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

