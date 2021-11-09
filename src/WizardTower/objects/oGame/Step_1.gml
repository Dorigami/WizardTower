/// @description reset gridSpace values

var i,j;
var _node = undefined;
var _valid = false;
var _dist = 0;
var _dir = 0;
var _x = 0;
var _y = 0;
var _xCell = 0;
var _yCell = 0;
var _max = 0;
var _densityWeight = 0.1;

for(i=0;i<GRID_WIDTH;i++)
{
for(j=0;j<GRID_HEIGHT;j++)
{
	_node = global.gridSpace[# i,j];
	_node.discomfort = 0; // g = discomfort
    _node.density = [0,0,0,0]; // rho = density
}
}

//with(oFollower2)
//{
//	_xCell = (x div CELL_SIZE);
//	_yCell = (y div CELL_SIZE);
//	for(var xx=-1;xx<=1;xx++)
//	{
//	for(var yy=-1;yy<=1;yy++)
//	{
//		if(_xCell+xx < 0) || (_xCell+xx >= GRID_WIDTH) || (_yCell+yy < 0) || (_yCell+yy >= GRID_HEIGHT) continue;
//		_node = global.gridSpace[# _xCell+xx, _yCell+yy];
//		_node.density[EAST]  = min(global.densityMax, _node.density[EAST] + _densityWeight*point_distance(x,y,_node.center[1]+0.5*CELL_SIZE,_node.center[2]));
//		_node.density[NORTH] = min(global.densityMax, _node.density[NORTH] + _densityWeight*point_distance(x,y,_node.center[1],_node.center[2]-0.5*CELL_SIZE));
//		_node.density[WEST]  = min(global.densityMax, _node.density[WEST] + _densityWeight*point_distance(x,y,_node.center[1]-0.5*CELL_SIZE,_node.center[2]));
//		_node.density[SOUTH] = min(global.densityMax, _node.density[SOUTH] + _densityWeight*point_distance(x,y,_node.center[1],_node.center[2]+0.5*CELL_SIZE));
//	}
//	}
//}

