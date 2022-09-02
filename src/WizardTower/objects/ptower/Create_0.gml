/// @description 

// Inherit the parent event
event_inherited();

show_debug_message("tower stats init: " + 
                   "\n" + object_get_name(object_index) + 
				   "\ncost: " + string(cost)
				   );

//damage = stats.damage;
//armorpierce = stats.armorpierce;
//cooldown = stats.cooldown;
//range = stats.range;
//detect = stats.detect;
//moneyMod = stats.moneyMod;

attackScript = -1;
targetList = ds_list_create();
targetRefresh = 10;
cdTimer = -1;
targetLimit = 1;


radialOptions = -1;
radialArgs = -1;
radialActive = false;
radialCheck = radialActive;

//start checking for enemies
alarm[1] = 1;

function GetEnemies(){
	var _x = x+0.5*TILE_SIZE;
	var _y = y+0.5*TILE_SIZE;
	var _r = range*TILE_SIZE;
	ds_list_clear(targetList)
	collision_circle_list(_x,_y,_r,pUnit,false,true,targetList,false);
	while(ds_list_size(targetList) > targetLimit)
	{
		ds_list_delete(targetList,ds_list_size(targetList)-1)
	}
}

