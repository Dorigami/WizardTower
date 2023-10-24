function merge_sort(_list, _criteria){
  // [ _list ] is an array with each element being a sub-array.
  // [ _criteria ] determines which element of the sub-array to use in sorting _list
  
  // returns the sorted array, called '_list'
  if(array_length(_list) > 1)
  {
    // Divide the list into two halves.
    var mid = array_length(_list) div 2;
    var L = [];
    var R = [];
    array_copy(L,0,_list,0,mid);
    array_copy(R,0,_list,mid,array_length(_list)-mid);
	
    // Recursively sort the two halves.
    merge_sort(L, _criteria);
    merge_sort(R, _criteria);

    // Merge the two sorted halves into the original list.
    var i=0, j=0, k=0;
    while(i < array_length(L)) && (j < array_length(R))
	{
		if(L[i][_criteria] < R[j][_criteria])
		{
			_list[k] = L[i];
			i++;
		} else {
			_list[k] = R[j];
			j++;
		}
		k++;
	}
    // Copy the remaining elements from the left half, if any.
    while(i < array_length(L))
	{
		_list[k] = L[i]
		i++;
		k++;
	}
    // Copy the remaining elements from the right half, if any.
    while(j < array_length(R))
	{
		_list[k] = R[j]
		j++;
		k++;
	}
  }
  return _list;	
}
function PosToCoord(_sample, _origin, _rad){
	return floor((_sample-_origin)/_rad);// div _rad;
}
function HashCell(_xx,_yy){
	var a = _xx*8089;
	var b = _yy*9737333;
	return a+b;
}
function GetKeyFromHash(_hash, _len){
	var _rtn = _hash % _len
	return sign(_rtn) == -1 ? _len + _rtn : _rtn;
}
function UpdateSpatialLookup(){
	var _list = particle_list;
	var _rad = particle_smoothing_radius;
	var _pt = undefined;
	// create unordered spatial lookup
	for(var i=0;i<particle_count;i++)
	{
		_pt = particle_list[| i]
		spatial_lookup[i][VAL] = i
		spatial_lookup[i][KEY] = _pt.cellkey;
	}
	// sort by cell key
	spatial_lookup = merge_sort(spatial_lookup, KEY)
	
	// calculate start indices
	var _key = 0;
	var _key_prev = 0;
	for(var i=0;i<particle_count;i++)
	{
		_key = spatial_lookup[i][KEY];
		_key_prev = i == 0 ? -1 : spatial_lookup[i-1][KEY];
		if(_key != _key_prev)
		{
			start_indices[_key] = i;
		}
	}
}
function ForEachPointInRadius(_function){
	var _in_range = 0;
	// find which cell the sample point is in (this will be the center of the 3x3 block)
	var _indices = global.iSimulation.start_indices;
	var _lookup = global.iSimulation.spatial_lookup;
	var _list = global.iSimulation.particle_list;
	var _count = global.iSimulation.particle_count;
	var _rad = global.iSimulation.particle_smoothing_radius;
	var _center = global.iSimulation.sim_center;
	var _pt = undefined;
	var _key = 0, _cell_start_index = 0;
	var _sqr_dist = 0;
	var _dist = 0;
	var _sqr_rad = power(_rad,2);
	var _xx = PosToCoord(position[1], _center[1],_rad);
	var _yy = PosToCoord(position[2], _center[2],_rad);
	// loop over all cells of the 3x3 block
	for(var i=-1;i<=1;i++){
	for(var j=-1;j<=1;j++){
		_key = GetKeyFromHash(HashCell(_xx+i, _yy+j), _count);
		_cell_start_index = _indices[_key];
		
		if(_cell_start_index == -1) continue;
		
		for(var k=_cell_start_index; k<_count; k++)
		{
			// exit loop if we're no longer looking at the correct cell
			if(_lookup[k][KEY] != _key) break;
			_pt = _list[| _lookup[k][VAL]];
			_sqr_dist = power(point_distance(position[1], position[2], _pt.position[1], _pt.position[2]), 2);
			
			// check if particle is within the radius
			if(_sqr_dist <= _sqr_rad)
			{
				_in_range++;
				script_execute(_function, _pt);
			}
		}
	}}
}
function ViscositySmoothingKernel(_dist, _rad){
	if(_dist >= _rad) return 0;
	
	var _vol = pi*power(_rad, 8) / 4;
	var _val = max(0, _rad*_rad-_dist*_dist);
	return power(_val,3) / _vol;
}
function SmoothingKernel(_dist, _rad){
	if(_dist >= _rad) return 0;
	
	var _vol = pi*power(_rad, 4) / 6;
	return (_rad-_dist)*(_rad-_dist) / _vol;
}
function SmoothingKernelDerivative(_dist, _rad){
	if(_dist >= _rad) return 0;
	
	var _scale = 12 / (power(_rad,4)*pi);
	return (_dist-_rad)*_scale;
}
function CalculateSharedPressure(_densityA, _densityB){
	var pressureA = ConvertDensityToPressure(_densityA);
	var pressureB = ConvertDensityToPressure(_densityB);
	return 0.5*(pressureA+pressureB);
}
function ConvertDensityToPressure(_density)
{
	with(global.iSimulation)
	{
		var _error = particle_target_density - _density;
		// determine pressure based on the error
		return _error * particle_pressure_multiplier;
	}
}
function CalculateDensityContribution(_other_particle){
	// loop over all particles within smoothing radius to get density
	var _dist = point_distance(
				_other_particle.pred_position[1], 
				_other_particle.pred_position[2], 
				pred_position[1],
				pred_position[2]);

	density += global.iSimulation.particle_mass*SmoothingKernel(_dist,global.iSimulation.particle_smoothing_radius);
}
function CalculatePressureContribution(_other_particle){
	// will increment the pressure force as a vector2
	
	// run pressure calculation for all nearby particles
	if(_other_particle.index == index) exit;
	// get distance and direction for pressure force calculation
	var _dist = point_distance(_other_particle.pred_position[1], _other_particle.pred_position[2], pred_position[1], pred_position[2]);
	var _dir = _dist == 0 ? 
		vect2(random(1),random(1)) : 
		vect_divr(vect2(_other_particle.pred_position[1]-pred_position[1], _other_particle.pred_position[2]-pred_position[2]), _dist);
	// fluid calculations
	var _slope = SmoothingKernelDerivative(_dist, global.iSimulation.particle_smoothing_radius);
	_dir = vect_multr(_dir, CalculateSharedPressure(density, _other_particle.density)*_slope*global.iSimulation.particle_mass/_other_particle.density);
	
	// increment pressure
	pressure[1] += _dir[1];
	pressure[2] += _dir[2];
}
function CalculateViscosityContribution(_other_particle){
	var _dist = point_distance(position[1],position[2], _other_particle.position[1], _other_particle.position[2]);
	var _influence = vect_subtract(_other_particle.velocity, velocity); 
	_influence = vect_multr(_influence, global.iSimulation.particle_viscosity*ViscositySmoothingKernel(_dist, global.iSimulation.particle_smoothing_radius));
	viscosity[1] += _influence[1];
	viscosity[2] += _influence[2];
}
function CalculateDensity(_sample_x, _sample_y){
	with(global.iSimulation)
	{
		var _density = 0;
		// loop over all particles within smoothing radius to get density
		for(var i=0;i<ds_list_size(particle_list);i++)
		{
			var _pt = particle_list[| i];
			var _dist = point_distance(_pt.pred_position[1], _pt.pred_position[2], _sample_x, _sample_y);
			_density += particle_mass*SmoothingKernel(_dist, particle_smoothing_radius);
		}
		return _density;
	}
}
function CalculateProperty(_sample_x, _sample_y){
	with(global.iSimulation)
	{
		var _prop = 0;
		// loop over all particles within smoothing radius to get density
		for(var i=0;i<ds_list_size(particle_list);i++)
		{
			var _pt = particle_list[| i];
			var _dist = point_distance(_pt.position[1], _pt.position[2], _sample_x, _sample_y);
			_prop += particle_mass*SmoothingKernel(_dist, particle_smoothing_radius);
		}
		return _prop;
	}
}
function CalculatePressureForce(_part_index){
	with(global.iSimulation)
	{
		// will return a gradient as a vector2
		var _pressure = vect2(0,0);
	
		var _pt_source = particle_list[| _part_index]; // source particle
		for(var i=-1;i<=1;i++){
		for(var j=-1;j<=1;j++){
			// get list conatining nearby particles
			var _list = particle_position_grid[# _pt_source.xx, _pt_source.yy];
			if(is_undefined(_list)) continue;
			// run pressure calculation for all nearby particles
			for(var k=0;k<ds_list_size(_list);k++)
			{
				if(_part_index == k) continue;
				var _pt_other = particle_list[| k];
				// get distance and direction for pressure force calculation
				var _dist = point_distance(_pt_other.position[1], _pt_other.position[2], _pt_source.position[1], _pt_source.position[2]);
				var _dir = _dist == 0 ? 
					vect2(random(1),random(1)) : 
					vect_divr(vect2(_pt_other.position[1]-_pt_source.position[1], _pt_other.position[2]-_pt_source.position[2]), _dist);
				// fluid calculations
				var _slope = SmoothingKernelDerivative(_dist, particle_smoothing_radius);
				var _sharedPressure = CalculateSharedPressure(_pt_source.density, _pt_other.density);
				_dir = vect_multr(_dir, _sharedPressure*_slope*particle_mass/_pt_other.density);
				// increment pressure
				_pressure[1] += _dir[1];
				_pressure[2] += _dir[2];
			}
		}}
		return _pressure;
	}
}