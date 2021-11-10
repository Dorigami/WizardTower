function MoveCommand(_id,_xTo,_yTo){
	with(_id)
	{
		destination = vect2(_xTo, _yTo);
		PathRequest([id], position, destination);
	}
}