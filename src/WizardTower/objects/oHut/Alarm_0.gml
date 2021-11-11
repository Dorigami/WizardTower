/// @description spawn timer for wizards

var _inst = ds_queue_dequeue(spawnQueue);
if(instance_exists(_inst))
{
	var _bestDir = 0;
	var _penalty = 0;
	var _node = undefined;
	// find neighboring node with the lowest discomfort
	for(var i=0; i<8; i++)
	{
		var _xCell = (myNode.center[1]+lengthdir_x(CELL_SIZE,i*45)) div GRID_WIDTH;
		var _yCell = (myNode.center[2]+lengthdir_y(CELL_SIZE,i*45)) div GRID_HEIGHT;
		_node = global.gridSpace[# _xCell, _yCell];
	}
}
