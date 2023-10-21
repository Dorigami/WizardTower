/// @description run game

time_check = current_time;

if(room == rShaderTest) exit;

hud_action = global.iHUD.hud_get_action();
mouse_action = handle_mouse();
action = handle_keys(global.game_state);

/*

if(keyboard_check_pressed(vk_anykey))
{
	show_debug_message("KEY PRESS\nkeyboard_key = {0}\nkeyboard_lastkey = {1}\nkeyboard_lastchar = {2}\nkeyboard_string = {3}\n--------------",keyboard_key, keyboard_lastkey, keyboard_lastchar, keyboard_string);
}
if(mouse_check_button_pressed(mb_any))
{
	show_debug_message("MOUSE PRESS\nmouse_lastbutton = {0}\n------------------", mouse_lastbutton);
}
//show_debug_message("ACTION = {0}\nMOUSE_ACTION = {1}", action, mouse_action);

*/

escape = action[$ "escape"];
if(is_undefined(escape)) escape = mouse_action[$ "escape"];
use_ability = action[$ "use_ability"]; 
if(is_undefined(use_ability)) use_ability = hud_action[$ "use_ability"];

camera_pan = action[$ "camera_pan"];
camera_fast_pan = action[$ "camera_fast_pan"];
camera_zoomout = mouse_action[$ "camera_zoomout"];
camera_zoomin = mouse_action[$ "camera_zoomin"];
selecting = mouse_action[$ "selecting"];
select_confirm = mouse_action[$ "select_confirm"];
select_cancel = mouse_action[$ "select_cancel"];
move_command = mouse_action[$ "move_command"];
attack_command = mouse_action[$ "attack_command"];
build_command = mouse_action[$ "build_command"];
bunker_command = mouse_action[$ "bunker_command"];
right_click = mouse_action[$ "right_click"];
right_release = mouse_action[$ "right_release"];
left_click = mouse_action[$ "left_click"];
left_release = mouse_action[$ "left_release"];
wheel_down = mouse_action[$ "wheel_down"];
wheel_up = mouse_action[$ "wheel_up"];
start_next_wave = action[$ "start_next_wave"];
change_build_type = action[$ "change_build_type"];
confirm_build_action = action[$ "confirm_build_action"];
confirm_build_action_mouse = mouse_action[$ "confirm_build_action"];
confirm_sell_action = action[$ "confirm_sell_action"];
confirm_sell_action_mouse = mouse_action[$ "confirm_sell_action"];
confirm_target_action = action[$ "confirm_target_action"];
confirm_target_action_mouse = mouse_action[$ "confirm_target_action"];

//--// game environment interaction
if(!is_undefined(camera_pan)){
	var _val = other.camera_pan.value;
	with(global.iCamera)
	{
		var _vect = vect2(_val[0], _val[1]);
		var _vect = vect_multr(vect_norm(_vect), spd);
		xTo += _vect[1];
		yTo += _vect[2];
	}
} else if(!is_undefined(camera_fast_pan)){
	var _val = other.camera_fast_pan.value;
	with(global.iCamera)
	{
		var _vect = vect2(_val[0], _val[1]);
		var _vect = vect_multr(vect_norm(_vect), spdFast);
		xTo += _vect[1];
		yTo += _vect[2];
	}
}

var _zoom = !is_undefined(camera_zoomout) + 2*!is_undefined(camera_zoomin);
if(_zoom > 0)
{
	if(alarm[1] == -1)
	{
		alarm[1] = zoom_delay_time;
		if(_zoom == 1){
			view_zoom = view_zoom == 0.5 ? 1 : 2; // zoom out
		} else {
			view_zoom = view_zoom == 2 ? 1 : 0.5; // zoom in
		}
		with(global.iCamera)
		{
			camera_set_view_size(cam, global.iEngine.idealWidth*global.iEngine.view_zoom, global.iEngine.idealHeight*global.iEngine.view_zoom);
			viewWidthHalf = round(0.5*camera_get_view_width(cam));
			viewHeightHalf = round(0.5*camera_get_view_height(cam));	
			camera_set_view_pos(cam, x-viewWidthHalf, y-viewHeightHalf);
		}
	}
}

if(!is_undefined(select_cancel)){
	with(global.iSelect) CancelSelection();
} else if(!is_undefined(select_confirm)){
	with(global.iSelect) ConfirmSelection();
} else if(!is_undefined(selecting)){
	with(global.iSelect) EnableSelection();
}

if(!is_undefined(move_command)){
	show_debug_message("move command");
	var _size = ds_list_size(player_actor.selected_entities);
	if(_size > 0)
	{
		if(player_actor.selected_entities[| 0].faction == PLAYER_FACTION)
		{
			for(var i=0; i<_size; i++)
			{
				var _ent = player_actor.selected_entities[| i];
				if(is_undefined(_ent.ai)) continue;
				// give command
				if(!keyboard_check(vk_shift))
				{
					ds_list_clear(_ent.ai.commands);
				} 
				ds_list_add(_ent.ai.commands, move_command);
			}
		}
	}
} else if(!is_undefined(attack_command)){
	show_debug_message("attack command");
	var _size = ds_list_size(player_actor.selected_entities);
	if(_size > 0)
	{
		if(player_actor.selected_entities[| 0].faction == PLAYER_FACTION)
		{
			for(var i=0; i<_size; i++)
			{
				var _ent = player_actor.selected_entities[| i];
				if(is_undefined(_ent.ai)) continue;
				// give command
				if(!keyboard_check(vk_shift))
				{
					ds_list_clear(_ent.ai.commands);
				} 
				ds_list_add(_ent.ai.commands, attack_command);
			}
		}
	}
} 

if(!is_undefined(start_next_wave))
{
	show_debug_message("starting next wave");	
	if(!is_undefined(enemy_actor.ai)) && (is_instanceof(enemy_actor.ai, DebugActorAI)) && (!enemy_actor.ai.start_next_wave)
	{
		enemy_actor.ai.start_next_wave = true;
	}
}

if(!is_undefined(change_build_type))
{
	show_debug_message("change build type");
	if(instance_exists(blueprint_instance))
	{
		with(blueprint_instance)
		{
			if(other.change_build_type.value < array_length(type_arr))
			{
				show_debug_message("value: {0}  is inside the range of available options: [{1}] {2}", other.change_build_type.value, array_length(type_arr), type_arr);
				var _stats = global.iEngine.actor_list[| PLAYER_FACTION].fighter_stats[$ type_arr[other.change_build_type.value]]
				type_string = type_arr[other.change_build_type.value];
				object = _stats.obj;
				size = _stats.size;
        		sprite_index = object_get_sprite(_stats.obj);
				mask_index = object_get_sprite(_stats.obj);
			} else {
				show_debug_message("value: {0}  is ouside of the size of available options: [{1}] {2}", other.change_build_type.value, array_length(type_arr), type_arr);
			}
		}
	}
}

if(!is_undefined(confirm_build_action)) || (!is_undefined(confirm_build_action_mouse))
{
	show_debug_message("Confirm Build Action");
	
	// 2) set the current build blueprint to the unit selected previously
	if(instance_exists(blueprint_instance))
	{
		var _ent = undefined;
		var _valid = true;
		var _actor = actor_list[| PLAYER_FACTION];
		var _stats = _actor.fighter_stats[$ blueprint_instance.type_string];
		show_debug_message("stats data = [ {0} / {1} ]", _stats.material_cost, _actor.material)
		// check for resources
		if(_stats.material_cost > _actor.material){ show_debug_message("not enough material"); _valid = false;}
		if(_actor.supply_current + _actor.supply_in_queue + _stats.supply_cost > _actor.supply_limit){ show_debug_message("not enough supply"); _valid = false;}
		if(_valid)
		{
			show_debug_message("build criteria met");
			// create the blueprint entity for the builder to target
			_ent = ConstructBlueprint(mouse_x, mouse_y, PLAYER_FACTION, blueprint_instance.type_string);
			if(is_undefined(_ent)) exit;
			if(!blueprint_instance.lock_to_grid)
			{
				_ent.x = mouse_x;
				_ent.y = mouse_y;
			} 
			_ent.xTo = mouse_x;
			_ent.yTo = mouse_y;
			
			// update supply and material
			_actor.supply_in_queue += _stats.supply_cost;
			_actor.material -= _stats.material_cost;

			// check if the unit can still be afforded
			_valid = false;
			if(keyboard_check(vk_shift))
			{
				if(_stats.material_cost <= _actor.material) && (_actor.supply_current + _actor.supply_in_queue + _stats.supply_cost <= _actor.supply_limit){
					_valid = true
				}
			} 
		} 
		
		// leave build state when no longer valid
		if(!_valid)
		{
			// remove the engine blueprint instance and reference
			if(instance_exists(blueprint_instance)) instance_destroy(blueprint_instance);
			blueprint_instance = noone;
			//update state
			global.game_state_previous = global.game_state;
			global.game_state = GameStates.PLAY;
		}
	} else {
		// cancel the build
		escape = true;
	}
}
if(!is_undefined(confirm_sell_action)) || (!is_undefined(confirm_sell_action_mouse))
{
	show_debug_message("Confirm Sell Action");
	
	if(global.iEngine.sell_price > 0)
	{
		for(var i=ds_list_size(player_actor.selected_entities)-1; i>=0; i--){
			with(player_actor.selected_entities[| i])
			{
				other.player_actor.material += material_cost;
				SellPuffCreate(position[1],position[2]);
				CreateFloatNumber(x,bbox_top,"+$"+string(material_cost),FLOATTYPE.LINEAR,90,40,0.3);
				ds_list_delete(other.player_actor.selected_entities, i);
				instance_destroy();
			}
		}
		SoundCommand(snd_sell,0,0);
	}
}

if(!is_undefined(confirm_target_action)) || (!is_undefined(confirm_target_action_mouse))
{
	show_debug_message("Confrim Target Action");
}

if(!is_undefined(use_ability))
{   
	var _ability = current_player_abilities[use_ability.value];
	if(!is_instanceof(_ability, global.iEngine.Ability))
	{
		show_debug_message("can't get/run ability, no stored struct");
		exit;
	}
	script_execute_array(_ability.script, _ability.args);
}
	
if(!is_undefined(escape)){
	show_debug_message("ESCAPE ACTION")
	if(global.game_state != GameStates.PAUSE)
	{
	//--// Cancel Current Action Based on the Current Game State
		switch(global.game_state)
		{
			case GameStates.BUILDING:
				show_debug_message("Cancel Building State");
				if(instance_exists(blueprint_instance)) 
				{
					instance_destroy(blueprint_instance);
					blueprint_instance = noone;
				}
				global.game_state = global.game_state_previous;
				break;
			case GameStates.SELLING:
				show_debug_message("Cancel Selling State");
				global.game_state = global.game_state_previous;
				break;
			case GameStates.TARGETING:
				show_debug_message("Cancel Targeting State");
				with(oTargeting) instance_destroy();
				global.game_state = global.game_state_previous;
				break;
			default:
				if(ds_stack_size(menu_stack) == 0)
				{
					// pause the game
					show_debug_message("Pause Game");
					global.game_state_previous = global.game_state;
					global.game_state = GameStates.PAUSE;
				} else {
					// remove menu off of the stack
					show_debug_message("Exit Current Menu");
					with(ds_stack_pop(menu_stack)) instance_destroy();
				}
				break;
		}
	} else {
		// unpause the game
		global.game_state = global.game_state_previous;
	}
}
time_check_input = current_time - time_check;
if(global.game_state != GameStates.PAUSE)
{
	with(pEntity)
	{
		EntityVisibility();
		
		// update blueprints
		if(!is_undefined(blueprint)) blueprint.Update();

		// update fighters (this mainly handles attack cooldowns)
		if(!is_undefined(fighter)) fighter.Update();

		// update structures (this mainly handles unit build queues)
		if(!is_undefined(structure)) structure.Update();

		// update units (mainly for builders)
		if(!is_undefined(unit)) unit.Update();

		// perform ai actions
		if(!is_undefined(ai)) ai.Update();

		// do basic entity updates
		Update();
	}
	time_check_entity_loop = current_time - time_check - time_check_input;
	// Actor Loop
	var _actor_size = ds_list_size(actor_list);
	if(_actor_size > 0)
	{
		for(var i=0; i<_actor_size; i++)
		{
			var _actor = actor_list[| i];
			with(_actor)
			{
				if(material_per_second > 0) material += material_per_second/FRAME_RATE;
				if(!is_undefined(ai))
				{
					if(action_timer > 0){
						if(--action_timer <= 0){
							action_timer = FRAME_RATE / (actions_per_minute/60);
							ai.GetAction();
						}
					} else { action_timer = FRAME_RATE / (actions_per_minute/60) }

					ai.Update();
				} 
			}
		}
	}
	time_check_actor_loop = current_time - time_check - time_check_input - time_check_entity_loop;
}
time_check_total_step = current_time - time_check;