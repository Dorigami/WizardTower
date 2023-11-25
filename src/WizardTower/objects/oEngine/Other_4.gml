/// @description 


if(room != rStartMenu) && (room != rInit) && (room != rShaderTest) && (room != rHexTest)
{
	//debug view
	dbg_view("processing times",true);
	dbg_section("Engine Step Timings (ms)");
	dbg_watch(ref_create(global.iEngine, "time_check_input"),"Inputs");
	dbg_watch(ref_create(global.iEngine, "time_check_entity_loop"),"Entity Loop");
	dbg_watch(ref_create(global.iEngine, "time_check_actor_loop"),"Actor Loop");
	dbg_watch(ref_create(global.iEngine, "time_check_misc"),"Misc");
	dbg_watch(ref_create(global.iEngine, "time_check_total_step"),"Total");
	
	room_start_init_game_grid();
	room_start_init_camera();
	room_start_init_abilities();
	room_start_init_player_stats();
	room_start_init_entities();

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
	
	// start music
	SoundCommand(The_Verdant_Grove_LOOP,0,0);
}

if(room == rHexTest)
{
	room_start_init_game_grid();
	room_start_init_camera();
	room_start_init_abilities();
	room_start_init_entities();
	
	
	InitHexagonalGrid(POINTYTOP, ODD_R, 20, room_width div 2, room_height div 2,21,21);
}
if(instance_exists(global.iHUD)) global.iHUD.Init();
