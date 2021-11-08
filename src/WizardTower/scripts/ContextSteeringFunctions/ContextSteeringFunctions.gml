function AvoidObstructions(_x, _y, _blocked, _notWalkable){
	var _nodeList = ds_list_create();
	var _slowRange = CELL_SIZE;
	var _maskRange = CELL_SIZE-5;
	var _weight = 0;
	var _dist = 0;
	var _x2 = 0;
	var _y2 = 0;
	var _dist = 0; // distance
	var _dir = 0; // direction 
	var _node = undefined;
	var _map = 0; // new map to be added to the set
	var _uNode = 0; // unit vector to node point
	var _uMap = 0; // unit vector of context map
	var _xCell = _x div CELL_SIZE;
	var _yCell = _y div CELL_SIZE;
	// get node & neighboring nodes, add them to a list
	for(var xx=-1;xx<=1;xx++)
	{
	for(var yy=-1;yy<=1;yy++)
	{
		// ensure node location is valid
		if(_xCell+xx < 0) || (_xCell+xx >= GRID_WIDTH) || (_yCell+yy < 0) || (_yCell+yy >= GRID_HEIGHT) continue;
		// get node
		_node = global.gridSpace[# _xCell+xx, _yCell+yy];
		// add node to list to be evaluated
		ds_list_add(_nodeList, _node);
	}
	}
	// get danger values for each node
	if(ds_list_size(_nodeList) > 0)
	{
		for(var i=0;i<ds_list_size(_nodeList);i++)
		{
			_node = _nodeList[| i];
			_dist = point_distance(x,y,_node.center[1], _node.center[2]);
			if(_dist > _slowRange) continue;
			if((_blocked) && (_node.blocked)) || ((_notWalkable) && (!_node.walkable))
			{
				_map = array_create(resolution, 0);
				_dir = point_direction(x,y,_node.center[1], _node.center[2]);
				_uNode = speed_dir_to_vect2(1,_dir);
				_weight = 1-((_dist-_maskRange)/(_slowRange-_maskRange)); // weight = 1 when within 30% of max range
				for(var k=0;k<resolution;k++)
				{ 
					
					_map[k] = _weight*vect_dot(speed_dir_to_vect2(1,k*(360 div resolution)), _uNode);
					if(_dist <= _maskRange) && (_map[k] > 0) mask[k] = true;
				}
				// add map to danger set
				ds_list_add(other.dSet, _map);
			}
		}
	}
	ds_list_destroy(_nodeList);
}

function csChasePath(_path){
	if(ds_exists(_path, ds_type_list)) && (ds_list_size(_path)>0)
	{
		var _range = 2000;
		var _rangeWeight = 0;
		var resolution = 12;
		var _dist = 0; // distance
		var _dir = 0; // direction 
		var _map = 0; // new map to be added to the set
		var _uObj = 0; // unit vector of the object
		var _uMap = 0; // unit vector of context map
		// get interest values
		_map = array_create(resolution, 0);
		_dist = point_distance(x,y,_path[| 0].center[1],_path[| 0].center[2]);
		if(_dist > _range) return;
		_rangeWeight = min(1,(1-(_dist/_range))/0.8); // weight = 1 when within 20% of max range
		_dir = point_direction(x,y,_path[| 0].center[1],_path[| 0].center[2]);
		_uObj = speed_dir_to_vect2(1,_dir);
		for(var i=0;i<resolution;i++)
		{
			_uMap = speed_dir_to_vect2(1,i*(360 div resolution))
			_map[i] = _rangeWeight*vect_dot(_uMap,_uObj);
		}
		ds_list_add(other.iSet, _map);
	}
}

function csChaseGoal(_goal){
	var _range = 2000;
	var _rangeWeight = 0;
	var resolution = 12;
	var _dist = 0; // distance
	var _dir = 0; // direction 
	var _map = 0; // new map to be added to the set
	var _uObj = 0; // unit vector of the object
	var _uMap = 0; // unit vector of context map
	// get interest values
	show_debug_message(string(_goal))
	_map = array_create(resolution, 0);
	_dist = point_distance(x,y,_goal[1],_goal[2]);
	if(_dist > _range) return;
	_rangeWeight = min(1,(1-(_dist/_range))/0.8); // weight = 1 when within 20% of max range
	_dir = point_direction(x,y,_goal[1],_goal[2]);
	_uObj = speed_dir_to_vect2(1,_dir);
	for(var i=0;i<resolution;i++)
	{
		_uMap = speed_dir_to_vect2(1,i*(360 div resolution))
		_map[i] = _rangeWeight*vect_dot(_uMap,_uObj);
	}
	ds_list_add(other.iSet, _map);
}

function csChase(_obj){
	var _range = 1000;
	var _rangeWeight = 0;
	var resolution = 12;
	var _dist = 0; // distance
	var _dir = 0; // direction 
	var _map = 0; // new map to be added to the set
	var _uObj = 0; // unit vector of the object
	var _uMap = 0; // unit vector of context map
	// get interest values
	with(_obj)
	{
		_map = array_create(resolution, 0);
		_dist = point_distance(x,y,other.x,other.y);
		if(_dist > _range) continue;
		_rangeWeight = min(1,(1-(_dist/_range))/0.8); // weight = 1 when within 20% of max range
		_dir = point_direction(other.x,other.y,x,y);
		_uObj = speed_dir_to_vect2(1,_dir);
		for(var i=0;i<resolution;i++)
		{
			_uMap = speed_dir_to_vect2(1,i*(360 div resolution))
			_map[i] = _rangeWeight*vect_dot(_uMap,_uObj);
		}
		ds_list_add(other.iSet, _map);
	}
}

function csAvoid(_obj){
	var _slowRange = 30;
	var _maskRange = 20;
	var _weight = 0;
	var _dist = 0; // distance
	var _dir = 0; // direction 
	var _map = 0; // new map to be added to the set
	var _uObj = 0; // unit vector of the object
	var _uMap = 0; // unit vector of context map
	// get interest values
	with(_obj)
	{
		if(other.id == id) continue;
		_map = array_create(resolution, 0);
		_dist = point_distance(x,y,other.x,other.y);
		if(_dist > _slowRange) continue;
		// calculate danger values and add the resulting context map to the danger set
		_weight = 1-((_dist-_maskRange)/(_slowRange-_maskRange)); // weight = 1 when within 30% of max range
		_dir = point_direction(other.x,other.y,x,y);
		_uObj = speed_dir_to_vect2(1,_dir);
		for(var i=0;i<resolution;i++)
		{
				_uMap = speed_dir_to_vect2(1,i*(360 div resolution));
				_map[i]	= _weight*vect_dot(_uMap,_uObj);			
				if(_dist > _maskRange) && (_map[i] > 0) mask[i] = true;
		}
		ds_list_add(other.dSet, _map);
	} 
}