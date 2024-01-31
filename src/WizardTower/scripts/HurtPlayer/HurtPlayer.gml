function HurtPlayerBySupply(){
	var _damage = unit.supply_cost;
	health -= _damage;
	with(global.iHUD)
	{
		with(CreateFloatNumber(player_data_x+44, player_data_y+10,"-"+string(_damage),FLOATTYPE.TICK,fDefault,90+2*irandom_range(-5,5),30,0.1,true))
		{
			image_blend = c_red;
			depth = other.depth-2;
		}	
	}
	
	if(health <= 0) 
	{
		audio_play_sound(snd_lose, 1, false);
		room_restart();
	} else {
		audio_play_sound(player_hurt, 2, false);
	}
}