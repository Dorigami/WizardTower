function ControlSchemeDefault(){
	inpPause = keyboard_check_pressed(vk_escape);
	inpRestart = keyboard_check_pressed(ord("R"));
	inpSelectionClear = keyboard_check_pressed(vk_space);
	inpMoveCommand = mouse_check_button_released(mb_right);
	inpUp = keyboard_check(ord("W"));
	inpLeft = keyboard_check(ord("A"));
	inpDown = keyboard_check(ord("S"));
	inpRight = keyboard_check(ord("D"));
	inpFastPan = keyboard_check(vk_shift);
	//// unit selection
	//if(mouse_check_button_released(mb_left)) 
	//{
	//	clickPos = -1;
	//	if(!global.onButton)
	//	{
	//		// if a structure was clicked, open it's radial menu
	//		var _inst = instance_place(mouse_x,mouse_y,pStructure);
	//		if(radialTarget != noone) && instance_exists(radialTarget) radialTarget.radialActive = false;
	//		radialTarget = _inst;
	//		if(_inst != noone) _inst.radialActive = true;
	//	}
	//}
	//if(mouse_check_button_pressed(mb_left)) 
	//{
	//	// check if player clicked on a button or a structure
	//	var _check = place_meeting(mouse_x,mouse_y,pStructure)
	//	if(!_check) && (!global.onButton)
	//	{
	//		// create unit selection object
	//		clickPos = vect2(mouse_x, mouse_y);
	//		instance_create_layer(clickPos[1],clickPos[2],"Instances",oSelect);
	//	}
	//}
	
////--// execute actions based on the active inputs
//	// clear selection
//	if(inpSelectionClear)
//	{
//		EmptySelection();
//	}
//	// move command selected units
//	if(inpMoveCommand)
//	{
//		if(ds_list_size(global.unitSelection) > 0)
//		{
//			for(var i=0; i<ds_list_size(global.unitSelection);i++)
//			{
//				with(global.unitSelection[| i])
//				{
//					if(state != STATE.SPAWN) || (state != STATE.DEAD) state = STATE.FREE;
//					MoveCommand(id, clamp(mouse_x,0,global.game_grid_width*TILE_SIZE-1), clamp(mouse_y,0,global.game_grid_height*TILE_SIZE-1),true);
//				}
//			}
//		}
//	}

//	// camera pan
//	if(abs(inpRight - inpLeft) || abs(inpDown - inpUp)) 
//	{
//		var _dir = point_direction(0, 0, inpRight - inpLeft, inpDown - inpUp)
//		var _panSpeed = 8;
//		with(global.iCamera)
//		{
//			direction = _dir;
//			follow = noone;
//			xTo += lengthdir_x(_panSpeed+other.inpFastPan*_panSpeed, direction);
//			yTo += lengthdir_y(_panSpeed+other.inpFastPan*_panSpeed, direction);
//			x = xTo; 
//			y = yTo;
//		} 
//	}
	// pause/end game
	if(inpPause)
	{
		// transition to the main menu
		if(room != rStartMenu) RoomTransition(TRANS_TYPE.FADE,rStartMenu,InitializeGameData,0.02);
	}
	if(inpRestart)
	{
		// restart the current level
		room_restart();
	}
}
function ControlSchemeStructurePlacement(){
	inpConfirm = mouse_check_button_pressed(mb_left);
	inpCancel = mouse_check_button_pressed(mb_right) || keyboard_check_pressed(vk_escape);
	inpPersist = keyboard_check(vk_shift);
	inpSelectionClear = keyboard_check_pressed(vk_space);
	inpUp = keyboard_check(ord("W"));
	inpLeft = keyboard_check(ord("A"));
	inpDown = keyboard_check(ord("S"));
	inpRight = keyboard_check(ord("D"));
	inpFastPan = keyboard_check(vk_shift);

	if(!instance_exists(target))
	{
		controlScheme = ControlSchemeDefault;
		exit;
	} else {
		with(target)
		{
			x = 0.5*TILE_SIZE + (mouse_x div TILE_SIZE)*TILE_SIZE;
			y = 0.5*TILE_SIZE + (mouse_y div TILE_SIZE)*TILE_SIZE;
		}
	}
	if(inpConfirm) 
	{
		if(ds_list_size(global.unitSelection) > 0)
		{
			for(var i=0;i<ds_list_size(global.unitSelection);i++) MoveCommand(global.unitSelection[| i].id,target.x,target.y,true);
		}
		if(inpPersist)
		{
			target = instance_create_layer(mouse_x,mouse_y,"Instances",target.object_index);
		} else {
			target = noone;
		}
	}
	if(inpCancel)
	{
		instance_destroy(target);
		target = noone;
	}
	// clear selection
	if(inpSelectionClear)
	{
		EmptySelection();
	}

	// camera pan
	if(abs(inpRight - inpLeft) || abs(inpDown - inpUp)) 
	{
		var _dir = point_direction(0, 0, inpRight - inpLeft, inpDown - inpUp)
		var _panSpeed = 8;
		with(global.iCamera)
		{
			direction = _dir;
			follow = noone;
			xTo += lengthdir_x(_panSpeed+other.inpFastPan*_panSpeed, direction);
			yTo += lengthdir_y(_panSpeed+other.inpFastPan*_panSpeed, direction);
			x = xTo; 
			y = yTo;
		} 
	}
}