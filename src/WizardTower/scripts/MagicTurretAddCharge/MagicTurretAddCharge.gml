function StructureAddAttackCharge(_structure, _object=-1){
	if(_object != -1){
		_structure.supply_current++;
		var _x = _structure.rally_x;
		var _y = _structure.rally_y;
		with(instance_create_depth(_x, _y, -_y-1, _object))
		{
			ds_list_add(_structure.units, id);
			creator = _structure.owner;
			xTo = _x;
			yTo = _y;
		}
	}
}