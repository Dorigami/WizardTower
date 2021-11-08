
function FindPath_Astar(_start=[2,0,0], _end=[2,0,0], _allowDiagonal){
    //convert world position into node positions 
    var _startNode = global.gridSpace[# _start[1] div CELL_SIZE, _start[2] div CELL_SIZE];
    var _endNode = global.gridSpace[# _end[1] div CELL_SIZE, _end[2] div CELL_SIZE];

    var openSet = global.controller.pathHeap; openSet.Initialize();
    var closedSet = ds_list_create();

    // add starting node to OPEN before looping
	_startNode.gCost = 0;
	_startNode.hCost = 0;
	openSet.Add(_startNode);

    // loop through currently open nodes
    while(openSet.Count() > 0)
    {
		var _currentNode = openSet.RemoveFirst();	
        // set currentNode as next in path
        ds_list_add(closedSet, _currentNode);

        if(_currentNode != _endNode)
        {
            // get neighboring cells for evaluation
            for(var xx=-1; xx<=1; xx++)
            {
            for(var yy=-1; yy<=1; yy++)
            {
				if(!_allowDiagonal) && (abs(xx)+abs(yy) == 2) continue;
                if(_currentNode.cell[1]+xx > -1) && (_currentNode.cell[1]+xx < GRID_WIDTH) && (_currentNode.cell[2]+yy > -1) && (_currentNode.cell[2]+yy < GRID_HEIGHT)
				{
					var _neighbor = global.gridSpace[# _currentNode.cell[1]+xx, _currentNode.cell[2]+yy];
	                if(!is_undefined(_neighbor)) && (_neighbor != _currentNode) && (_neighbor.walkable) && (ds_list_find_index(closedSet,_neighbor) == -1) && (!openSet.Contains(_neighbor)) 
	                {
	                    var _costToNeighbor = _currentNode.gCost + point_distance(_currentNode.center[1],_currentNode.center[2],_neighbor.center[1],_neighbor.center[2]) + _neighbor.discomfort;
						if(_costToNeighbor < _neighbor.gCost) || (!openSet.Contains(_neighbor))
						{
		                    _neighbor.gCost = _costToNeighbor
		                    _neighbor.hCost = point_distance(_endNode.center[1],_endNode.center[2],_neighbor.center[1],_neighbor.center[2]);
		                    _neighbor.parent = _currentNode;
							
		                    // add/update neighbor
							openSet.Add(_neighbor);
						}
	                }
				}
            }
            }
        }
    }

    // retrace path
    var _path = ds_list_create();
    var _node = _endNode;
    while(_node != _startNode) 
    {
        ds_list_insert(_path, 0, _node); 
        _node = _node.parent;
    }
    return _path;
}

GridNode = function(_xCell=0,_yCell=0) constructor
{
    walkable = true; // whether the cell is part of the playspace
    blocked = false; // whether the cell has something built on it
    discomfort = 0; // g = discomfort
    density = [0,0,0,0]; // rho = density
	gCost = 0;
	hCost = 0;
	parent = undefined;
	HeapIndex = 0;
    cell = vect2(_xCell,_yCell);
    center = vect2(_xCell*CELL_SIZE+0.5*CELL_SIZE, _yCell*CELL_SIZE+0.5*CELL_SIZE);
	static fCost = function(){
	    return gCost + hCost;
	}	
	static CompareTo = function(_otherNode){
		// return 1 if current node has higher priority (lower fCost/hCost)
		// return -1 if current node has lower priority
		var _compare = 0;
		if(gCost != _otherNode.gCost)
		{
			// pick priority
			_compare = gCost < _otherNode.gCost ? 1 : -1;
		}else{
			// tie breaker
			_compare = hCost < _otherNode.hCost ? 1 : -1;
		}
		return _compare;
	}
}

NodeHeap = function() constructor
{
	currentItemCount = 0;
	maxHeapSize = GRID_WIDTH*GRID_HEIGHT;
	items = array_create(maxHeapSize, -1);

	static Initialize = function(){
		items = array_create(maxHeapSize, -1)
		currentItemCount = 0;
	}
	static Add = function(_item){
		_item.HeapIndex = currentItemCount;
		items[currentItemCount] = _item;
		SortUp(_item);
		currentItemCount++;
	}
	static RemoveFirst = function(){
		var _firstItem = items[0];
		currentItemCount--;
		items[0] = items[currentItemCount];
		items[0].HeapIndex = 0;
		SortDown(items[0]);
		return _firstItem;
	}
	static UpdateItem = function(_item){
		SortUp(_item);
	}
	static Count = function(){
		return currentItemCount;
	}
	static Contains = function(_item){
		return array_equals(items[_item.HeapIndex].cell, _item.cell);
	}
	static SortUp = function(_item){
		var _parentIndex = (_item.HeapIndex-1)/2;
		while(true)
		{
			var _parentItem = items[_parentIndex];
			if(_item.CompareTo(_parentItem) > 0)
			{
				Swap(_item,_parentItem);
			} else {
				break;
			}
			_parentIndex = (_item.HeapIndex-1)/2;
			return _parentIndex;
		}
	}
	static SortDown = function(_item){
		while(true)
		{
			var _childIndexLeft = _item.HeapIndex*2 + 1; 
			var _childIndexRight = _item.HeapIndex*2 + 2;
			var _swapIndex = 0;
			
			if(_childIndexLeft < currentItemCount)
			{
				_swapIndex = _childIndexLeft;
				
				if(_childIndexRight < currentItemCount)
				{
					if(items[_childIndexLeft].CompareTo(items[_childIndexRight]) < 0)
					{
						_swapIndex = _childIndexRight;
					}
				}
				if(_item.CompareTo(items[_swapIndex]) < 0)
				{
					Swap(_item, items[_swapIndex]);
				} else {
					return;
				}
			} else {
				return;
			}
		}
	}
	static Swap = function(itemA,itemB){
		items[itemA.HeapIndex] = itemB;
		items[itemB.HeapIndex] = itemA;
		var _itemAIndex = itemA.HeapIndex;
		itemA.HeapIndex = itemB.HeapIndex;
		itemB.HeapIndex = _itemAIndex;
	}
}

PathTicket = function(_units,_startPoint,_endPoint) constructor{
	units = _units;
	startPoint = _startPoint;
	endPoint = _endPoint;
}

function PathRequest(_units, _startPoint, _endPoint){
	// sends a ticket to the controller to return a path to the goal
	var _ticket = new PathTicket(_units, _startPoint, _endPoint);
	with(global.controller) ds_queue_enqueue(pathQueue, _ticket);
}


