function HurtPlayerBySupply(){
	health -= unit.supply_cost;
	if(health <= 0) 
	audio_play_sound(snd_lose,1,false);
	room_restart();
}