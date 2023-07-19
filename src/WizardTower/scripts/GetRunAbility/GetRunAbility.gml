function GetRunAbility(_entities, _ind){
	var _ab_index = 0, _ab_arr = [];
	var _size = array_length(_entities);
	var _entity = undefined;
	var unit_comp, structure_comp; 
	for(var i=0; i<_size; i++)
	{
		_entity = _entities[i];
		if(!is_undefined(_entity))
		{
			unit_comp = _entity.unit;
			structure_comp = _entity.structure;
			if(!is_undefined(unit_comp)){
				// use unit ability
				_ab_arr = _entity.unit.abilities;
			} else if(!is_undefined(structure_comp)){
				// use structure ability
				_ab_arr = _entity.structure.abilities;
			} else {
				
			}
			if(_ind < array_length(_ab_arr))
			{
				// get an run the ability
				with(_entity) script_execute(_ab_arr[_ind]);
			}
		}
	}
}