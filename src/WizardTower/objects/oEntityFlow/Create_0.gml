/// @description create the spatial lookup


sim_center = vect2(0,0);


function room_start_init_simulation(){
	sim_bbox[0] = 0;
	sim_bbox[1] = 0;
	sim_bbox[2] = 900;
	sim_bbox[3] = 780;
	sim_center[1] = 0.5*(sim_bbox[2]+sim_bbox[0]);
	sim_center[2] = 0.5*(sim_bbox[3]+sim_bbox[1]);
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
	UpdateSmoothingRadius(particle_smoothing_radius);
}