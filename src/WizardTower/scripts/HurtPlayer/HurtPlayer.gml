function HurtPlayerBySupply(){
	health -= unit.supply_cost;
	if(health <= 0) room_restart();
}