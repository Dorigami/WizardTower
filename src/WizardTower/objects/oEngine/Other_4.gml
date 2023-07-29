/// @description 


if(room != rStartMenu) && (room != rInit)
{
	health = 20;
	room_start_init_game_grid();
	room_start_init_camera();
	room_start_init_abilities();
	// RoomStartInitMap();
	// RoomStartInitEntities();

	// create the ai behavior component for the actors, based on the current room
	var _ai_component = new DebugActorAI();
	_ai_component.owner = enemy_actor;
	enemy_actor.ai = _ai_component;
	
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
}

global.iHUD.Init();
