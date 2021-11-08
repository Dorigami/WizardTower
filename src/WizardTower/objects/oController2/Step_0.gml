/// @description 

//--// pathing queue
if(ds_queue_size(pathQueue) > 0)
{
	var _ticket = ds_queue_head(pathQueue);
	var _path = FindPath_Astar(_ticket.startPoint, _ticket.endPoint, false);
	for(var i=0; i< array_length(_ticket.units); i++)
	{
		var _unit = _ticket.units[i];
		if(instance_exists(_unit)) 
		{
			with(_unit)
			{
				//if(ds_exists(path, ds_type_list)) ds_list_destroy(path);
				path = _path;
			}
		}
	}
	ds_queue_dequeue(pathQueue);
}

if(keyboard_check_pressed(ord("Y"))){
	instance_create_layer(mouse_x,mouse_y,"Instances",oGoal2);
}
if(keyboard_check_pressed(ord("H"))){
	with(oGoal2){ 
		instance_destroy(); 
		break;
	}
}
if(keyboard_check_pressed(ord("U"))){
	instance_create_layer(mouse_x,mouse_y,"Instances",oObstacle2);
}
if(keyboard_check_pressed(ord("J"))){
	with(oObstacle2){
		instance_destroy(); 
		break;
	}
}

// toggle blocked by right clicking
if(mouse_check_button(mb_right))
{
	var _node = global.gridSpace[# mouse_x div CELL_SIZE, mouse_y div CELL_SIZE];
	if(!is_undefined(_node)) && (ds_list_find_index(cellToggleList,_node)==-1)
	{
		_node.walkable = !_node.walkable;
		ds_list_add(cellToggleList, _node);
	}
}

if(mouse_check_button_released(mb_right))
{
	ds_list_clear(cellToggleList);
}
