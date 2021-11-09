function RoomTransition(_type, _targetroom, _script, _speed){
	if(!instance_exists(oTransition))
	{
		with(instance_create_depth(0,0,-9999,oTransition))
		{
			type = _type;
			target = _targetroom;
			if(!is_undefined(_speed)) transitionSpeed = _speed;
			if(!is_undefined(_script)) transitionScript = _script;
		}
	} else {
		show_message("trying to transition while transition is happening!");
	}
}