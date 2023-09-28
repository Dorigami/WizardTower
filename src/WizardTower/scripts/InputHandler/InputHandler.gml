/*
    the input handlers need to run inside of the engine, or else the variable references will be out of scope
*/
double_click_time = 3;
double_click_timer = -1;

//--// MOUSE HANDLERS //--//
function handle_mouse(){
    if(global.game_state == GameStates.PLAY)
    {
        return handle_play_mouse();
    } else if(global.game_state == GameStates.TARGETING){
        return handle_targeting_mouse();
	} else if(global.game_state == GameStates.BUILDING){
		return handle_building_mouse();
	} else if(global.game_state == GameStates.SELLING){
		return handle_selling_mouse();
	} else {
        return handle_default_mouse();
    }
}

function handle_play_mouse(){
	// left mouse
	if(mouse_check_button_released(mb_left)){
        if(global.iSelect.enabled){
            return {select_confirm : new Command("select_confirm", true, 0, 0)}
        } else {
            return {left_release : new Command("left_release", true, mouse_x, mouse_y)}
        }
    } else if mouse_check_button_pressed(mb_left){
        if(ds_stack_size(menu_stack) <= 1){
            if(global.hud_focus == -1)
            {
                // start selection process
                return {selecting : new Command("selecting",true,0,0)}
            } else {
                // do nothing (this may change later; action buttons will trigger as a seperate input)
            }
        } else {
            return {left_click : new Command("left_click",true,mouse_x, mouse_y)}
        }
    }
	// right mouse
	if(mouse_check_button_released(mb_right)){
        return { right_release : new Command("right_release",true,mouse_x, mouse_y) }
    } else if(mouse_check_button_pressed(mb_right)){
        if(global.iSelect.enabled){
            return { select_cancel : new Command("select_cancel",true,0,0) }
        } else {
            if(global.hud_focus != -1){
				show_debug_message("registering input");
                return { right_click : new Command("right_click",true,mouse_x, mouse_y) }
            } else if(global.mouse_focus != noone){
                if(ds_list_size(player_actor.selected_entities) > 0)
                {
                    // have the engine decide what the selected units do with the target
					
                    var _ent = global.mouse_focus; 
                    if(_ent.faction == PLAYER_FACTION)
                    {
                        if(!is_undefined(_ent.unit)) {}; // follow command
                        if(!is_undefined(_ent.structure)) {}; // move to nearest cell
                        if(!is_undefined(_ent.bunker)) return { bunker_command : new Command("bunker",_ent,_ent.x,_ent.y) };
                        return { move_command : new Command("move",true,mouse_x,mouse_y) };
                    } else {
                        if(!is_undefined(_ent.fighter)) return { attack_command : new Command("attack",_ent,_ent.x,_ent.y) };
                        return { move_command : new Command("move",true,mouse_x,mouse_y) };
                    }
                } else {
                    // display a pop-up with the entity's properties
                    // return { examine_entity : [global.mouse_focus] }
                }
            } else {
                // assign movement goals to each entity currently selected
                return { move_command : new Command("move",true,mouse_x,mouse_y) }
            }
        }
	}
	// middle mouse / wheel
	if(mouse_check_button_pressed(mb_middle)){
        return {middle_click : new Command("middle_click",true,mouse_x,mouse_y)}
    } else if(mouse_wheel_up()){
        if(ds_stack_size(menu_stack) > 1)
        {
            return { wheel_up : new Command("wheel_up",true,0,0) }
        } else {
            return { camera_zoomin : new Command("camera_zoomin",true,0,0) }
        }
    } else if(mouse_wheel_down()){
        if(ds_stack_size(menu_stack) > 1){
            return { wheel_down : new Command("wheel_down",true,0,0) }
        } else {
            return { camera_zoomout : new Command("camera_zoomout",true,0,0) }
        }
    } 
    return {}
}

function handle_building_mouse(){
	// left mouse
	if(mouse_check_button_released(mb_left)){
		if(!keyboard_check(vk_shift)) return {escape : new Command("escape",true,0,0)}
	} else if(mouse_check_button_pressed(mb_left)){
		return {confirm_build_action : new Command("confirm_build_action",true,0,0)}
	}

	// right mouse
	if(mouse_check_button_released(mb_right)){
		show_debug_message("building mouse event");
        return {escape : new Command("escape",true,0,0)}
    } 
    else if(mouse_check_button_pressed(mb_right)){}

	// middle mouse / wheel
	if(mouse_check_button_pressed(mb_middle)){}
    else if(mouse_wheel_up()){}
    else if(mouse_wheel_down()){}
    
    return {}
}
function handle_selling_mouse(){
	// left mouse
	if(mouse_check_button_released(mb_left)){
        if(global.iSelect.enabled){
            return {select_confirm : new Command("select_confirm", true, 0, 0)}
        } else {
            return {left_release : new Command("left_release", true, mouse_x, mouse_y)}
        }
    } else if mouse_check_button_pressed(mb_left){
        if(ds_stack_size(menu_stack) <= 1){
            if(global.hud_focus == -1)
            {
                // start selection process
                return {selecting : new Command("selecting",true,0,0)}
            } else {
                // do nothing (this may change later; action buttons will trigger as a seperate input)
            }
        } else {
            return {left_click : new Command("left_click",true,mouse_x, mouse_y)}
        }
    }
	// right mouse
	if(mouse_check_button_released(mb_right)){
        return { right_release : new Command("right_release",true,mouse_x, mouse_y) }
    } else if(mouse_check_button_pressed(mb_right)){
        if(global.iSelect.enabled){
            return { select_cancel : new Command("select_cancel",true,0,0) }
        } else {
            if(global.hud_focus != -1){
				show_debug_message("registering input");
                return { right_click : new Command("right_click",true,mouse_x, mouse_y) }
            } else {
                return { escape : new Command("escape",true,0,0) }
            }
        }
	}

	// middle mouse / wheel
	if(mouse_check_button_pressed(mb_middle)){}
    else if(mouse_wheel_up()){}
    else if(mouse_wheel_down()){}
    
    return {}
}

function handle_targeting_mouse(){
	// left mouse
	if(mouse_check_button_released(mb_left)){} 
    else if mouse_check_button_pressed(mb_left){}

	// right mouse
	if(mouse_check_button_released(mb_right)){
        return {escape : new Command("escape",true,0,0)}
    } 
    else if(mouse_check_button_pressed(mb_right)){}

	// middle mouse / wheel
	if(mouse_check_button_pressed(mb_middle)){}
    else if(mouse_wheel_up()){}
    else if(mouse_wheel_down()){}
    
    return {}
}

function handle_default_mouse(){
	// left mouse
	if(mouse_check_button_released(mb_left)){} 
    else if mouse_check_button_pressed(mb_left){}

	// right mouse
	if(mouse_check_button_released(mb_right)){} 
    else if(mouse_check_button_pressed(mb_right)){}

	// middle mouse / wheel
	if(mouse_check_button_pressed(mb_middle)){}
    else if(mouse_wheel_up()){}
    else if(mouse_wheel_down()){}
    
    return {}
}

//--// KEYBOARD HANDLERS //--//

function handle_keys(game_state){
    if(game_state == GameStates.PAUSE){
        return handle_pause_keys();
    } else if(game_state == GameStates.PLAY){
        return handle_play_keys();
    } else if(game_state == GameStates.BUILDING){
        return handle_building_keys();
    } else if(game_state == GameStates.SELLING){
        return handle_selling_keys();
    } else if(game_state == GameStates.TARGETING){
        return handle_targeting_keys();
    } else if(game_state == GameStates.VICTORY){
        return handle_victory_keys();
    } else if(game_state == GameStates.DEFEAT){
        return handle_defeat_keys();
    } else if(game_state == GameStates.MAIN_MENU){
        return handle_main_menu_keys();
    } else if(game_state == GameStates.UPGRADE_MENU){
        return handle_upgrade_menu_keys();
    }
}

function handle_play_keys(){
	// debug mode
	if(keyboard_check_pressed(vk_f3))
	{
		global.iDebugInspector.visible = !global.iDebugInspector.visible;
	}
    // abilities
	for(var i=0; i<9; i++)
	{
		if(keyboard_check_pressed(ord(ability_hotkeys[i]))) return {use_ability : new Command("use_ability",i,0,0)}
	}

    // begin waves / start next wave
    if(keyboard_check_pressed(vk_enter)){
        // toggle fullscreen
        if(keyboard_check(vk_alt))
        {
            window_set_fullscreen(!window_get_fullscreen());
        } else {
        // start next wave
            return {start_next_wave : new Command("start_next_wave",true,0,0)}    
        }
    }

    // pause
    if(keyboard_check_pressed(vk_escape))
    {
		if(global.iSelect.enabled)
		{
			return {select_cancel : new Command("select_cancel",true,0,0)}
		} else {
			return {escape : new Command("escape",true,0,0)}
		}
	}

    // camera pan
    var _move = [keyboard_check(ord("D")) - keyboard_check(ord("A")), keyboard_check(ord("S")) - keyboard_check(ord("W"))];
    var _fast_pan = keyboard_check(vk_shift);
    if(_move[0] != 0) || (_move[1] != 0) 
    {
        if(_fast_pan){
            return {camera_fast_pan : new Command("camera_fast_pan",_move,0,0)};
        } else {
            return {camera_pan : new Command("camera_pan",_move,0,0)};
        }
    }

    return {}
}
function handle_pause_keys(){
    // unpause
    if(keyboard_check_pressed(vk_escape))
    {
        return {escape : new Command("escape",true,0,0)}
    }
    return {}
}
function handle_building_keys(){
    // cancel build location
    if(keyboard_check_pressed(vk_escape))
    {
        return {escape : new Command("escape",true,0,0)}
    }

    // confirm build location
    if(keyboard_check_released(ord("E")))
    {
		if(!keyboard_check(vk_shift)) return {escape : new Command("escape",true,0,0)}
    } else if(keyboard_check_pressed(ord("E"))){
		return {confirm_build_action : new Command("confirm_build_action",true,0,0)}
	}
    // abilities
	for(var i=0; i<9; i++)
	{
		if(keyboard_check_pressed(ord(ability_hotkeys[i]))) return {use_ability : new Command("use_ability",i,0,0)}
	}
/*
    // select different entity type to build (accept num keys 1-9 on keyboard and/or numpad)
    var _ord = 0;
    for(var i=0; i<9; i++)
    {
        _ord = 49+i;
        if(keyboard_check_pressed(_ord)) || (keyboard_check_pressed(_ord+48))
        {
            return {change_build_type : new Command("change_build_type", i, 0, 0)}
        }
    }
*/
    // camera pan
    var _move = [keyboard_check(ord("D")) - keyboard_check(ord("A")), keyboard_check(ord("S")) - keyboard_check(ord("W"))];
    var _fast_pan = keyboard_check(vk_shift);
    if(_move[0] != 0) || (_move[1] != 0) 
    {
        if(_fast_pan){
            return {camera_fast_pan : new Command("camera_fast_pan",_move,0,0)};
        } else {
            return {camera_pan : new Command("camera_pan",_move,0,0)};
        }
    }

    return {}
}
function handle_selling_keys(){
    // cancel selling
    if(keyboard_check_pressed(vk_escape))
    {
        return {escape : new Command("escape",true,0,0)}
    }
	
    // confirm sell action
    if(keyboard_check_pressed(ord("E")))
    {
        return {confirm_sell_action : new Command("confirm_sell_action",true,0,0)}
    }
	
	// abilities
	for(var i=0; i<9; i++)
	{
		if(keyboard_check_pressed(ord(ability_hotkeys[i]))) return {use_ability : new Command("use_ability",i,0,0)}
	}
	
    // camera pan
    var _move = [keyboard_check(ord("D")) - keyboard_check(ord("A")), keyboard_check(ord("S")) - keyboard_check(ord("W"))];
    var _fast_pan = keyboard_check(vk_shift);
    if(_move[0] != 0) || (_move[1] != 0) 
    {
        if(_fast_pan){
            return {camera_fast_pan : new Command("camera_fast_pan",_move,0,0)};
        } else {
            return {camera_pan : new Command("camera_pan",_move,0,0)};
        }
    }

    return {}
}
function handle_targeting_keys(){
    // cancel action
    if(keyboard_check_pressed(vk_escape))
    {
        return {escape : new Command("escape",true,0,0)}
    }

    // camera pan
    var _move = [keyboard_check(ord("D")) - keyboard_check(ord("A")), keyboard_check(ord("S")) - keyboard_check(ord("W"))];
    var _fast_pan = keyboard_check(vk_shift);
    if(_move[0] != 0) || (_move[1] != 0) 
    {
        if(_fast_pan){
            return {camera_fast_pan : new Command("camera_fast_pan",_move,0,0)};
        } else {
            return {camera_pan : new Command("camera_pan",_move,0,0)};
        }
    }

    return {}
}
function handle_victory_keys(){
    return {}
}
function handle_defeat_keys(){
    return {}
}
function handle_main_menu_keys(){
    return {}
}
function handle_upgrade_menu_keys(){
    return {}
}


