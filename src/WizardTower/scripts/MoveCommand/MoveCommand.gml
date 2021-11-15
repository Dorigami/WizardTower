function MoveCommand(_id,_xTo,_yTo,_findTarget){
	with(_id)
	{
		destination = vect2(_xTo, _yTo);
		PathRequest([id], position, destination);
		// get a target
		if(_findTarget)
		{
			target = instance_place(_xTo, _yTo, pUnit);
			if(target == noone) target = instance_place(_xTo, _yTo, pStructure);
			if(target == noone) target = instance_place(_xTo, _yTo, pResource);
		}
	}
}