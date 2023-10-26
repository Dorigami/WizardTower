/// @description create the spatial lookup

function InitParticles(_randomize=false){
	sim_started = false;
	
	// get particles to their initial state
	// clamp rows and columns
	particle_rows = clamp(particle_rows, 0, 30);
	particle_columns = clamp(particle_columns, 0, 30);

	var _part_count = particle_rows*particle_columns;
	// create required particles, delete unnecessary particles
	if(ds_list_size(particle_list) > _part_count)
	{
		// remove particles
		for(var k=ds_list_size(particle_list);k>_part_count;k--){
			delete particle_list[| k-1];
			ds_list_delete(particle_list, k-1);
		}
		
	} else if(ds_list_size(particle_list) < particle_rows*particle_columns){
		// create more particles
		for(var k=ds_list_size(particle_list);k<_part_count;k++){
			CreateParticle(0,0,0,0,particle_diameter/sprite_get_width(sParticle));
		}
	}
	particle_count = ds_list_size(particle_list);
	
	array_resize(spatial_lookup,particle_count);
	array_resize(start_indices,particle_count);
	// allow the spatial lookup
	for(var i=0;i<particle_count;i++){
		var _pt = particle_list[| i];
		if(!is_array(spatial_lookup[i])) spatial_lookup[i] = array_create(2,i);
		_pt.cellkey = GetKeyFromHash(HashCell(_pt.xx,_pt.yy), global.iSimulation.particle_count);
		spatial_lookup[i][KEY] = _pt.cellkey;
		start_indices[i] = -1;
	}
	
	var k = -1;
	var _col_offset = particle_columns div 2;
	var _row_offset = particle_rows div 2;
	var _x_mid = 0.5*(sim_bbox[2]-sim_bbox[0]);
	var _y_mid = 0.5*(sim_bbox[3]-sim_bbox[1]);
	
	// set positions
	for(var i=0;i<particle_columns;i++){
	for(var j=0;j<particle_rows;j++){
		with(particle_list[| ++k])
		{
			if(_randomize){
				with(global.iSimulation)
				{
					other.position[1] = irandom_range(sim_bbox[0],sim_bbox[2]);
					other.position[2] = irandom_range(sim_bbox[1], sim_bbox[3]);
				}
			} else {
				position[1] = _x_mid + (i-_col_offset)*other.particle_separation;
				position[2] = _y_mid + (j-_row_offset)*other.particle_separation;
			}
			xx = PosToCoord(position[1],global.iSimulation.sim_center[1],global.iSimulation.particle_smoothing_radius);
			yy = PosToCoord(position[2],global.iSimulation.sim_center[2],global.iSimulation.particle_smoothing_radius);
			cellkey = GetKeyFromHash(HashCell(xx,yy),global.iSimulation.particle_count);
			velocity[1] = 0;
			velocity[2] = 0;
		}
	}} 
	UpdateSpatialLookup();
}

function room_start_init_simulation(){
	image_xscale = sim_bbox[2] - sim_bbox[0];
	image_yscale = sim_bbox[3] - sim_bbox[1];
	image_blend = c_navy;
	var _seperation = 50;
	var _rows = 1;
	var _columns = 1;
	var _xoffset = _columns div 2;
	var _yoffset = _rows div 2;
	for(var i=0;i<_columns;i++){
	for(var j=0;j<_rows;j++){
		var _xx = 0.5*(sim_bbox[0] + sim_bbox[2]);
		var _yy = 0.5*(sim_bbox[1] + sim_bbox[3]);
		CreateParticle(
			_xx+((i-_xoffset)*_seperation),
			_yy+((j-_yoffset)*_seperation),
			0, 0, particle_diameter/sprite_get_width(sParticle));
	}}
	InitParticles();
	UpdateSmoothingRadius(entity_smoothing_radius);
}