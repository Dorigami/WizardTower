/// @description spawn timer for wizards

var _inst = ds_queue_dequeue(spawnQueue);
if(instance_exists(_inst))
{
	var _bestDir = 0;
	var _bestDiscomfort = 9999999999999;
	var _node = undefined;
	var _arr = array_create(8, 0);
	// find neighboring node with the lowest discomfort
	for(var i=0; i<8; i++)
	{
		var _xCell = (myNode.center[1]+lengthdir_x(CELL_SIZE,i*45)) div CELL_SIZE;
		var _yCell = (myNode.center[2]+lengthdir_y(CELL_SIZE,i*45)) div CELL_SIZE;
		_node = global.gridSpace[# _xCell, _yCell];
		if(!is_undefined(_node)) && (_node.discomfort < _bestDiscomfort)
		{
			_bestDir = i*45;
			_bestDiscomfort = _node.discomfort;
		}
	}
	// spawn the unit and set their destination
	_xCell = (myNode.center[1]+lengthdir_x(CELL_SIZE,_bestDir)) div CELL_SIZE;
	_yCell = (myNode.center[2]+lengthdir_y(CELL_SIZE,_bestDir)) div CELL_SIZE;
	_node = global.gridSpace[# _xCell, _yCell];
	with(_inst)
	{
		direction = _bestDir;
		visible = true;
		x = other.x;
		y = other.y;
		position = vect2(x,y);
		MoveCommand(id, _node.center[1], _node.center[2]);
	}
}
