function MarcherGetTarget(_inst){
	// this must be given an instance id
	var _target = noone;
	with(_inst)
	{
		// resolve fighter behavior
		with(fighter)
		{
			// attack the current attack target, if possible
			if(attack_target != noone) && (instance_exists(attack_target))
			{
				// check if enemy is still in range
				if(ds_list_find_index(enemies_in_range, attack_target) == -1)
				{
					attack_target = noone;
				} else {
					_target = attack_target;
				}
			} else {
				attack_target = noone;
			}
			// if there is no attack target, attack nearest enemy
			if(_target == noone)
			{
				var _has_barricade = false;
				for(var i=0; i<ds_list_size(enemies_in_range); i++)
				{
					var _enemy = enemies_in_range[| i];
					if(!is_undefined(_enemy)) && instance_exists(_enemy) && (_enemy.object_index == oBarricade)
					{
						// target the closest barricade
						if(_target == noone) { 
							_target = _enemy;
						} else {
							// pick new enemy instead if it's closer
							if(point_distance(other.position[1], other.position[2], _enemy.position[1], _enemy.position[2]) < point_distance(other.position[1], other.position[2], _target.position[1], _target.position[2]))
							{
								_target = _enemy;
							}
						}
					}
				}
			}
		}

	}
	return _target;
}
function GoliathGetTarget(){

}
function GoliathGetTarget(){

}
function GoliathGetTarget(){

}
function GoliathGetTarget(){

}