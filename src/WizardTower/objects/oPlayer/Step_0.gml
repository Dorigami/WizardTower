/// @description 
if(!global.gamePaused)
{
//--// MOUSE EFFECTS
		
		
//--// CONTROLS
	// checl for inputs from the current control scheme
	if(controlScheme != -1) script_execute(controlScheme);
	
	// execute actions based on the active inputs
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
	// camera controls
	// camera pan
	with(global.iCamera)
	{
		direction = point_direction(0, 0, other.inpRight - other.inpLeft, other.inpDown - other.inpUp);
		var _panSpeed = 8;
		if(abs(other.inpRight - other.inpLeft) || abs(other.inpDown - other.inpUp)) 
		{
			//show_debug_message("pan direction: " + string(direction) 
			//	              +"\nleft-right: "+ string(abs(_right - _left))
			//				  +"\ndown-up: "+ string(abs(_down - _up))
			//);
			follow = noone;
			xTo += lengthdir_x(_panSpeed+other.inpFastPan*_panSpeed, direction);
			yTo += lengthdir_y(_panSpeed+other.inpFastPan*_panSpeed, direction);
			x = xTo; 
			y = yTo;
		} 
	}
}

