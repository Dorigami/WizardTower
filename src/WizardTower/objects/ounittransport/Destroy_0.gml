/// @description 

if(killed)
{
	var _stats = global.iGame.defaultStats[? oUnitGrunt];
	var _struct = {
	    path : path,
	    hp : _stats.hp,
	    damage : _stats.damage,
	    spd : _stats.spd,
	    armor : _stats.armor,
	    stealth : _stats.stealth,
	    money : _stats.money   
	};
	repeat(4)
	{
		with(instance_create_layer(x,y,"Instances",oUnitGrunt,_struct))
		{
			x = other.x;
			y = other.y;
			position[1] = x;
			position[2] = y;
			pathPos = other.pathPos;
		}
	}
}
