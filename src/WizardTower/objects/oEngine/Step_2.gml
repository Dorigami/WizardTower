/// @description 

while(ds_queue_size(killing_floor) > 0){
	with(ds_queue_dequeue(killing_floor))
	{
		// create an object to play death animation
		if(spr_death != -1)
		{
			var _data = {
				sprite_index : spr_death
			}
			instance_create_depth(position[1], position[2], depth, oDeath, _data);
		}
		// destroy entity
		instance_destroy(); 
	}
}

