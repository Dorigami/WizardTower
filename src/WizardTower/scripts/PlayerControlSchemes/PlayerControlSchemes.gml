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
	// unit selection
	if(mouse_check_button_released(mb_left)) clickPos = -1;
	if(mouse_check_button_pressed(mb_left)) 
	{
		clickPos = vect2(mouse_x, mouse_y);
		instance_create_layer(clickPos[1],clickPos[2],"Instances",oSelect);
	}
//--// execute actions based on the active inputs
	// clear selection
	if(inpSelectionClear)
	{
		EmptySelection();
	}
	// move command selected units
	if(inpMoveCommand)
	{
		if(ds_list_size(global.unitSelection) > 0)
		{
			for(var i=0; i<ds_list_size(global.unitSelection);i++)
			{
				MoveCommand(global.unitSelection[| i], 
					        clamp(mouse_x,0,GRID_WIDTH*CELL_SIZE-1), 
							clamp(mouse_y,0,GRID_HEIGHT*CELL_SIZE-1),
							true
							);
			}
		}
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
			x = mouse_x;
			y = mouse_y;
		}
	}
	if(inpConfirm) 
	{
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