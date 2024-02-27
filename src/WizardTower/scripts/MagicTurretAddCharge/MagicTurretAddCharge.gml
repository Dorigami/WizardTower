function StructureAddAttackCharge(_entity){
	var _charge_object = -1;
	switch(_entity.object_index)
	{
		case oMagicTurret:
			_charge_object = oMagicBoltCharge;
			break;
	}
	if(_charge_object != -1){
		with(_entity.structure)
		{
			// init
			supply_current++;
			var _x = rally_x;
			var _y = rally_y;
		
			// create object to represent the attack charge
			with(instance_create_depth(_x, _y, -_y-1, _charge_object))
			{
				ds_list_add(other.units, id);
				creator = other.owner;
				xTo = _x;
				yTo = _y;
			}
		
			// update the data needed by the ai component
			with(_entity.ai)
			{
				array_resize(charge_rot_points,_entity.structure.supply_current);
			}
		}
	}
}