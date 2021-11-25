/// @description control the game

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
				if(ds_exists(path, ds_type_list)) ds_list_destroy(path);
				path = _path;
				if(ds_list_size(path) > 0) direction = point_direction(x, y, path[| 0].center[1], path[| 0].center[2]);
			}
		}
	}
	ds_queue_dequeue(pathQueue);
	delete _ticket;
}

