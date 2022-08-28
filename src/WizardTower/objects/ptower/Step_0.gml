/// @description 

if(!global.gamePaused)
{
	// attack when cooldown timer is done && a valid target exists
	if(cdTimer > -1) cdTimer--;
	var _size = ds_list_size(targetList);
	if(cdTimer <= 0) && (_size > 0)
	{
		var _inst = noone;
		var _ind = min(targetLimit, _size);

		// attack as many units as allowed
		for(var i=0;i<_ind;i++)
		{
			_inst = targetList[| i];
			if(instance_exists(_inst)) script_execute(attackScript, _inst);
		}
	}
}
