function StructureRadialLogic(){
	if(radialOptions != -1) && (radialActive != radialCheck)
	{
		radialCheck = radialActive;
		if(radialActive)
		{
			// create the radial buttons
			var _len = array_length(radialOptions);
			if(_len && 1)
			{
				show_debug_message("len is odd" + string(_len));
				var _angles = [90,45,135,0,180,-45,225];
			} else {
				show_debug_message("len is even " + string(_len));
				var _angles = [112,68,24,-20,156,-64,200];
			}
			for(var i=0;i<_len;i++)
			{
				var _dir = _angles[i];
				var _args = radialArgs[i];
				radialOptions[i] = CreateButton(_args[0],_args[1],x,y,_args[4],_args[5],_args[6],_args[7],_args[8],_args[9]);
				with(radialOptions[i])
				{
					direction = _dir;
					creator = other.id;
				}
			}
		} else {
			// remove the radial buttons
			for(var i=0;i<array_length(radialOptions);i++)
			{
				instance_destroy(radialOptions[i])
				radialOptions[i] = noone;
			}
		}
	}
}