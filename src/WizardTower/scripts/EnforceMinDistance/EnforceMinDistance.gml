function EnforceMinDistance(other_entity, _is_flyer=false){
	// this function prevents unit-type entities from stacking on top of one another
	// function will return false if the entities are too far apart, anf returns true if the min distance is enforced
	// 
	var _mindistance = collision_radius + other_entity.collision_radius;
	var _dist = point_distance(position[1],position[2],other_entity.position[1],other_entity.position[2]);
	var _diff = _mindistance-_dist; if(_diff <= 0) return false;
	var _split = collision_radius / _mindistance;
	var _dir = point_direction(position[1],position[2],other_entity.position[1],other_entity.position[2]);
	if(position[1] + position[2] - other_entity.position[1] - other_entity.position[2] == 0) { _dir = irandom(359) }
	
	if(_is_flyer) && (other_entity.z == 0) exit;
	
	if(moveable)
	{
		position[1] += _diff*(1-_split)*dcos(_dir-180);
		position[2] -= _diff*(1-_split)*dsin(_dir-180);
	}
	with(other_entity)
	{
		if(moveable)
		{
			position[1] += _diff*_split*dcos(_dir);
			position[2] -= _diff*_split*dsin(_dir);
		}
	}
	return true;
}