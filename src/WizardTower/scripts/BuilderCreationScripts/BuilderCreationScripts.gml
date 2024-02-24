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

		var _gridlock = true;
		
		// clear unit selection
		with(global.iSelect)
		{
		
		}
		
		// change state
		global.game_state_previous = global.game_state;
		global.game_state = GameStates.BUILDING;
		if(global.game_state_previous == GameStates.BUILDING) global.game_state_previous = GameStates.PLAY;
		
		// initialize state
		var _hex = global.i_hex_grid.mouse_hex_coord;
		var _pos = global.i_hex_grid.mouse_hex_pos;
		
		show_debug_message("creating blueprint, type string is {0}", _type_string)
		var _struct = {
			lock_to_grid : _gridlock,
			hex : _hex,
			type_string : _type_string,
			object : _stats.obj,
			entity_type : _stats.entity_type,
			size : _stats.size,
			collision_radius : round(0.6*GRID_SIZE),
			sprite_index : asset_get_index("s_"+_type_string+"_idle"),
			mask_index : asset_get_index("s_"+_type_string+"_idle"),
			faction : _faction}
		blueprint_instance = instance_create_layer(_pos[1], _pos[2], "Instances", oBlueprint, _struct);
		show_debug_message("blueprint's type string is: {0}", blueprint_instance.type_string);
	}
} 


function BuildStateUnit(){ BuilderCreate("summoner", true) }
function BuildStateStructure(){ BuilderCreate("conduit", false) }

function BuilderCreateBarricade(_faction) { BuilderCreate("barricade", _faction) }
function BuilderCreateGunTurret(_faction) { BuilderCreate("gunturret", _faction) }
function BuilderCreateSniper(_faction) { BuilderCreate("sniperturret", _faction) }
function BuilderCreateBarracks(_faction) { BuilderCreate("barracks", _faction) }
function BuilderCreateBombDrone(_faction) { BuilderCreate("dronesilo", _faction) }
function BuilderCreateMagicTurret(_faction) { BuilderCreate("magicturret", _faction) }
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
		if(global.game_state == GameStates.SELLING) exit;
		with(global.iSelect){EmptySelection(global.iEngine.player_actor)}
		global.game_state_previous = global.game_state;
		global.game_state = GameStates.SELLING;
		if(global.game_state_previous == GameStates.BUILDING) 
		{
			with(global.iEngine)
			{
				global.game_state_previous = GameStates.PLAY;
				if(instance_exists(blueprint_instance))
				{
					instance_destroy(blueprint_instance);
					blueprint_instance = noone;
				}
			}
		}
}
function player_upgrade_health_up(_val=0){
	if(_val == 0) exit;
	increase_health(_val, PLAYER_FACTION);
}
function player_upgrade_supply_up(_val=0){
	with(global.iEngine)
	{
		var _actor = player_actor;
		_actor.supply_limit += _val;
	}	
}
function player_upgrade_money_up(_val=0.1){
	with(global.iEngine)
	{
		var _actor = player_actor;
		_actor.money_rate += _val;
		_actor.material += 100;
	}
}
function increase_health(_val, _faction){
	if(_faction == PLAYER_FACTION){
		health += _val;
		
		var  _cmd = sign(_val) == 1 ? 
			new global.iEngine.Command("increase_player_health", _val, 0, 0):
			new global.iEngine.Command("decrease_player_health", _val, 0, 0);
			
		with(global.iHUD){ ds_queue_enqueue(command_queue, _cmd) }
	} else {
		// nothing
	}
}
function increase_money(_val, _faction){
	if(_val == 0) exit;
	var _actor = global.iEngine.actor_list[| _faction];
	// modify the value by player's money rate
	if(sign(_val) == 1)
	{
		_val *= _actor.money_rate;
		var _cmd = new global.iEngine.Command("increase money", _val, 0, 0);
	} else {
		var _cmd = new global.iEngine.Command("decrease money", _val, 0, 0);
	}
	
	// increment money
	_actor.material += floor(_val);
	// let the HUD object know about it
	with(oHUD){ ds_queue_enqueue(command_queue, _cmd) }
}
