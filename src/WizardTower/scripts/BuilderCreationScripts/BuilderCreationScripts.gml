function BuilderCreate(_type_string, _faction){
	with(global.iEngine)
	{
		var _actor = actor_list[| _faction];
		var _stats = _actor.fighter_stats[$ _type_string];
		// remove existing blueprint
		if(instance_exists(blueprint_instance)) 
		{
			instance_destroy(blueprint_instance);
			blueprint_instance = noone;
		}

		var _type_arr = ["barricade","gunturret","sniperturret","barracks","dronesilo","flameturret","mortarturret"];
		var _gridlock = true;
		
		// change state
		global.game_state_previous = global.game_state;
		global.game_state = GameStates.BUILDING;
		if(global.game_state_previous == GameStates.BUILDING) global.game_state_previous = GameStates.PLAY;
		
		// initialize state
		var _xx = mouse_x div GRID_SIZE; _xx = clamp(_xx,0,global.game_grid_width-1);
		var _yy = mouse_y div GRID_SIZE; _yy = clamp(_yy,0,global.game_grid_height-1);
		show_debug_message("creating blueprint, type string is {0}", _type_string)
		var _struct = {
			lock_to_grid : _gridlock,
			xx : _xx,
			yy : _yy,
			type_string : _type_string,
			object : _stats.obj,
			size : _stats.size,
			collision_radius : round(0.6*GRID_SIZE),
			sprite_index : asset_get_index("s_"+_type_string+"_idle"),
			mask_index : asset_get_index("s_"+_type_string+"_idle"),
			faction : _faction,
			type_arr : _type_arr}
		blueprint_instance = instance_create_layer(_xx*GRID_SIZE, _yy*GRID_SIZE, "Instances", oBlueprint, _struct);
		show_debug_message("blueprint's type string is: {0}", blueprint_instance.type_string);
	}
} 

//function BuilderCreateBase(_faction){ BuilderCreate("base", _faction) }
//function BuilderCreateBarracks(_faction){ BuilderCreate("barracks", _faction) }
//function BuilderCreateTurret(_faction){ BuilderCreate("turret", _faction) }
//function BuilderCreateBarricade(_faction){ BuilderCreate("barricade", _faction) }
//function BuilderCreateSentry(_faction){ BuilderCreate("sentry", _faction) }



function BuildStateUnit(){ BuilderCreate("summoner", true) }
function BuildStateStructure(){ BuilderCreate("conduit", false) }

function BuilderCreateBarricade(_faction) { BuilderCreate("barricade", _faction) }
function BuilderCreateGunTurret(_faction) { BuilderCreate("gunturret", _faction) }
function BuilderCreateSniper(_faction) { BuilderCreate("sniperturret", _faction) }
function BuilderCreateBarracks(_faction) { BuilderCreate("barracks", _faction) }
function BuilderCreateBombDrone(_faction) { BuilderCreate("dronesilo", _faction) }
function BuilderCreateFlameTurret(_faction) { BuilderCreate("flameturret", _faction) }
function BuilderCreateMortarTurret(_faction) { BuilderCreate("mortarturret", _faction) }
function ToggleEntityInfo(){
    with(global.iHUD){ 
		show_data_overlay = !show_data_overlay 
		show_debug_message("data overlay is now: " + string(show_data_overlay));
	}
}
function ToggleSellMode(){
		// change state
		global.game_state_previous = global.game_state;
		global.game_state = GameStates.SELLING;
		if(global.game_state_previous == GameStates.BUILDING) global.game_state_previous = GameStates.PLAY;
}


// light beam (basic)
// spread firelight (active)
// unit (toggle though units once targeting begins)
// lamp (sc2 pylon)
// barricade  (sc2 force field)
// 