/// @description update targetList
var _inst = noone;
var _x1 = x+0.5*TILE_SIZE;
var _y1 = y+0.5*TILE_SIZE;

// remove units that get too far away
for(var i=ds_list_size(targetList)-1;i>=0;i--)
{
	_inst = targetList[| i];
	if(is_undefined(_inst)) || (!instance_exists(_inst)) || (point_distance(_x1,_y1,_inst.x,_inst.y) > range*TILE_SIZE) 
	{
		if(object_index == oTowerIce)
		{
			// restore speed
			_inst.spd = global.iGame.defaultStats[? _inst.object_index].spd;
		}
		ds_list_delete(targetList,i);
	}
}
// redo collisions
if(ds_list_size(targetList) < targetLimit)
{
	GetEnemies();
	if(object_index == oTowerIce) && (ds_list_size(targetList))
	{
		var _slowMag = damage*0.1;
		for(var i=ds_list_size(targetList)-1;i>=0;i--)
		{
			_inst = targetList[| i];
			if(!is_undefined(_inst)) && (instance_exists(_inst))
			{
				_inst.spd = _slowMag * global.iGame.defaultStats[? _inst.object_index].spd;
			}
		}
	}
}


alarm[1] = targetRefresh;

