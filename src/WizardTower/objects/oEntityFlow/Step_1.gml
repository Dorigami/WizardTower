/// @description Insert description here
// You can write your code in this editor



if(global.game_state != GameStates.PAUSE)
{
	// set spatial lookup prior to density and pressure calc's
	UpdateSpatialLookup();
		
	// precalculate particle properties & data structures
	for(var i=0;i<ds_list_size(particle_list);i++){
		particle_list[| i].DensityCalc();	
	}	
	// calculate pressure
	for(var i=0;i<particle_count;i++){
		particle_list[| i].PressureCalc();
		//particle_list[| i].pressure = CalculatePressureForce(i);	
	}	
	// calculate viscosity
	for(var i=0;i<particle_count;i++){
		particle_list[| i].ViscosityCalc();
	}
	// update fluid behavior
	for(var i=0;i<particle_count;i++){
		particle_list[| i].Update();	
	}
}
