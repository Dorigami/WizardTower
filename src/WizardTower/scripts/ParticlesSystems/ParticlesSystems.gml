function ParticleSystemsInit(){
	ptsys_sell_puff = 0;
	ptsys_structure_spawn_puff = 0;
	ptsys_upgrade_effect = 0;
	ptsys_specialization_effect = 0;
}
function SellPuffInit(){
	with(global.iEngine)
	{
		if(!part_system_exists(ptsys_sell_puff)) ptsys_sell_puff = part_system_create();
		part_system_depth(ptsys_sell_puff,UPPERTEXDEPTH);
		pt_sell_puff = part_type_create();
		part_type_shape(pt_sell_puff,pt_shape_disk);
		part_type_speed(pt_sell_puff,0.5,1.5,0.005,0);
		part_type_size(pt_sell_puff,0.2,0.4,0.005,0.1);
		part_type_color3(pt_sell_puff,color0,color1,color7);
		part_type_direction(pt_sell_puff,0,359,0,0);
		part_type_gravity(pt_sell_puff,0.05,90);
		part_type_life(pt_sell_puff,10,40);
		part_type_alpha3(pt_sell_puff,1,0.2,0.0);
	}
}
function SellPuffCreate(_x,_y){
	with(global.iEngine)
	{
		part_particles_create(ptsys_sell_puff,_x,_y,pt_sell_puff,20);
	}
}
function StructureSpawnPuffInit(){
	with(global.iEngine)
	{
		if(!part_system_exists(ptsys_structure_spawn_puff)) ptsys_structure_spawn_puff = part_system_create();
		
		part_system_depth(ptsys_structure_spawn_puff,UPPERTEXDEPTH);
		pt_structure_spawn_puff = part_type_create();
		part_type_shape(pt_structure_spawn_puff,pt_shape_square);
		part_type_speed(pt_structure_spawn_puff,0.5,1.5,0.005,0);
		part_type_size(pt_structure_spawn_puff,0.2,0.4,0.005,0.1);
		part_type_color3(pt_structure_spawn_puff,color0,color1,color7);
		part_type_direction(pt_structure_spawn_puff,0,359,0,0);
		part_type_gravity(pt_structure_spawn_puff,0.05,90);
		part_type_life(pt_structure_spawn_puff,10,40);
		part_type_alpha3(pt_structure_spawn_puff,1,0.2,0.0);
	}
}
function StructureSpawnPuffCreate(_x,_y){
	with(global.iEngine)
	{
		part_particles_create(ptsys_structure_spawn_puff,_x,_y,pt_structure_spawn_puff,20);
	}
}
function UpgradeEffectInit(){
	with(global.iEngine)
	{
		if(!part_system_exists(ptsys_upgrade_effect)) ptsys_upgrade_effect = part_system_create();
		
		part_system_depth(ptsys_upgrade_effect,UPPERTEXDEPTH);
		pt_upgrade_effect = part_type_create();
		part_type_scale(pt_upgrade_effect,0.03,1.2);
		part_type_shape(pt_upgrade_effect, pt_shape_square);
		part_type_speed(pt_upgrade_effect,0.1,1.4,0.605,0);
		part_type_size(pt_upgrade_effect,0.4,0.5,0.12,0.1);
		part_type_color3(pt_upgrade_effect,color3,color4,color5);
		part_type_direction(pt_upgrade_effect,90,90,0,0);
		part_type_life(pt_upgrade_effect,20,30);
		part_type_alpha3(pt_upgrade_effect,1,0.4,0.0);
	}
}
function UpgradeEffectCreate(_x,_y){
	with(global.iEngine)
	{
		part_particles_create(ptsys_upgrade_effect,_x,_y,pt_upgrade_effect,20);
	}
}
