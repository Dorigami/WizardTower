/// @description 


if(room != rStartMenu) && (room != rInit) && (room != rShaderTest)
{
	//debug view
	/*
	dbg_view("processing times",true);
	dbg_section("Engine Step Timings (ms)");
	dbg_watch(ref_create(global.iEngine, "time_check_input"),"Inputs");
	dbg_watch(ref_create(global.iEngine, "time_check_entity_loop"),"Entity Loop");
	dbg_watch(ref_create(global.iEngine, "time_check_actor_loop"),"Actor Loop");
	dbg_watch(ref_create(global.iEngine, "time_check_misc"),"Misc");
	dbg_watch(ref_create(global.iEngine, "time_check_total_step"),"Total");
	*/
	
	room_start_init_game_grid();
	room_start_init_camera();
	room_start_init_abilities();
	room_start_init_player_stats();
	room_start_init_entities();
	
	InitHexagonalGrid(POINTYTOP, ODD_R, 32, room_width div 2, room_height div 2, 7, 7);
	
	// start music
	var _song = choose(The_Verdant_Grove_LOOP, Ludum_Dare_28___Track_4, Pixel_1, Pixel_2,Pixel_3,Pixel_4,Pixel_5,Pixel_6,Pixel_7,Pixel_8,Pixel_9,Pixel_10,Pixel_11,Pixel_12);
	SoundCommand(_song, 0, 0);
}

if(instance_exists(global.iHUD)) global.iHUD.Init();

// show_debug_message("HUD DIM: [{0}, {1}]", display_get_gui_width(), display_get_gui_height());
