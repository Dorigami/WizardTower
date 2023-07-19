/// @description 

/*

if(!global.gamePaused)
{
	// attack when cooldown timer is done && a valid target exists
	if(cdTimer > -1) cdTimer--;
	var _size = ds_list_size(targetList);
	if(cdTimer <= 0) && (_size > 0)
	{
		var _inst = noone;

		// attack as many units as allowed
		cdTimer = cooldown*FRAME_RATE;
		script_execute(attackScript);

		// remove defeated enemies
		for(var i=targetLimit-1;i>=0;i--)
		{
			_inst = targetList[| i];
			if(!instance_exists(_inst)) ds_list_delete(targetList,i);
		}
		// get enemies if there is no current target
		if(ds_list_size(targetList) == 0)
		{
			GetEnemies();
		}
	}
}
