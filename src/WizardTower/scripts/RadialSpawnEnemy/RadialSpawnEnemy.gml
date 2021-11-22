function RadialSpawnEnemy(_obj){
	with(creator)
	{
		var _inst = instance_nearest(x,y,oNexus);
		if(_inst != noone)
		{
			with(instance_create_layer(x,y,"Instances",_obj))
			{
				direction = point_direction(x,y,_inst.x,_inst.y);
				visible = true;
				position = vect2(x,y);
				active = true;
				MoveCommand(id, _inst.x, _inst.y);
				target = _inst;
			}
		}
	}
}