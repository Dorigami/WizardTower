/// @description 
if(!global.gamePaused)
{
//--// MOUSE EFFECTS
		
		
//--// CONTROLS
	var _selectionClear = keyboard_check_pressed(vk_space)
	var _moveCommand = mouse_check_button_released(mb_right);
	var _up, _left, _down, _right, _fastPan
	_up = keyboard_check(ord("W"));
	_left = keyboard_check(ord("A"));
	_down = keyboard_check(ord("S"));
	_right = keyboard_check(ord("D"));
	_fastPan = keyboard_check(vk_shift);
	// unit selection
	if(mouse_check_button_released(mb_left)) clickPos = -1;
	if(mouse_check_button_pressed(mb_left)) 
	{
		clickPos = vect2(mouse_x, mouse_y);
		instance_create_layer(clickPos[1],clickPos[2],"Instances",oSelect);
	}
	// clear selection
	if(_selectionClear)
	{
		EmptySelection();
	}
	// move command selected units
	if(_moveCommand)
	{
		if(ds_list_size(global.unitSelection) > 0)
		{
			for(var i=0; i<ds_list_size(global.unitSelection);i++)
			{
				MoveCommand(global.unitSelection[| i], 
					        clamp(mouse_x,0,GRID_WIDTH*CELL_SIZE-1), 
							clamp(mouse_y,0,GRID_HEIGHT*CELL_SIZE-1)
							);
			}
		}
	}
	// camera controls
	// camera pan
	with(global.iCamera)
	{
		direction = point_direction(0, 0, _right - _left, _down - _up);
		var _panSpeed = 8;
		if(abs(_right - _left) || abs(_down - _up)) 
		{
			//show_debug_message("pan direction: " + string(direction) 
			//	              +"\nleft-right: "+ string(abs(_right - _left))
			//				  +"\ndown-up: "+ string(abs(_down - _up))
			//);
			follow = noone;
			xTo += lengthdir_x(_panSpeed+_fastPan*_panSpeed, direction);
			yTo += lengthdir_y(_panSpeed+_fastPan*_panSpeed, direction);
			x = xTo; 
			y = yTo;
		} 
	}
}

