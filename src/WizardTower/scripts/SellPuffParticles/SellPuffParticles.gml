// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function SellPuffInit(){
	with(global.iEngine)
	{
		ptsys_sell_puff = part_system_create();
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