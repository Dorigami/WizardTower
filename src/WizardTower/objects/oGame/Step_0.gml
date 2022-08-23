/// @description control the game

if(keyboard_check_pressed(vk_f10))
{
	with(oMobSpawner) instance_destroy();
	instance_create_layer(0.5*room_width,0.5*room_height,"Instances",oMobSpawner);
	show_debug_message("mob spawner created")
}
if(keyboard_check_pressed(vk_f11))
{
	var _struct = { 
		path : pathMob0,
		hp : 10, 
		damage : 1,
		spd : 3, 
		armor : 1,
		stealth : false, 
		money : 20
	}
	repeat(5){
		instance_create_layer(0, 0, "Instances", oImp, _struct);
	}
	show_debug_message("mob has been created");
}

exit;

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
