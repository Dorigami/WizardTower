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
		
		// maintin order in the unit_id_list for fluid flow
		if(entity_type == UNIT)
		{
			var _list = unit_flow_struct.unit_id_list;
			ds_list_delete(_list, index);
			for(var i=0; i<ds_list_size(_list); i++)
			{
				var _inst = _list[| i];
				if(_inst.index != i) _inst.index = i;
				unit_flow_struct.unit_count_current--;
			}
		}
	}
}

