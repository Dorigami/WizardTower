DefenderAI = function() constructor{
    commands = ds_list_create(); // a list containing all command structs
	owner = undefined;
	
	static GetAction = function(){
		// check for command
		show_debug_message("get action doesn't really have a use at the moment");
	}
	static Update = function(){
		var _cmd = undefined;
		if(ds_list_size(commands) > 0)
		{
			_cmd = commands[| 0];
			// handle movement
			with(owner)
			{
				// resolve command updating conditions
				switch(_cmd.type){
					case "move":
					//--// check for movement interactions

						// goal is the command point
						if(xTo != _cmd.x) xTo = _cmd.x;
						if(yTo != _cmd.y) yTo = _cmd.y;

						if(point_distance(x,y,xTo,yTo) < collision_radius)
						{
							// anchor to the goal point before removing move command
							xAnchor = xTo;
							yAnchor = yTo;
							// remove move command
							delete ai.commands[| 0];
							ds_list_delete(ai.commands, 0);
							// coast toward the goal
							vel_force = vect_add(vel_force, vel_movement);
							vel_movement[1] = 0;
							vel_movement[2] = 0;
						}
						break;

					case "attack":
					//--// check for attack interactions
						if(instance_exists(_cmd.value))
						{
							// goal is the target's location
							if(xTo != _cmd.value.x) xTo = _cmd.value.x;
							if(yTo != _cmd.value.y) yTo = _cmd.value.y;
						} else {
							if(ds_list_size(ai.commands) > 0)
							{
								// remove attack command, and stay in place
								ds_list_delete(ai.commands, 0);
								_cmd = undefined;
								xTo = position[1];
								yTo = position[2];
							}
						}
						break;

					case "defend":
					//--// check for defend interactions	
						break;

					case "bunker":
					//--// check for bunker interactions
						break;

					default:
						show_debug_message("ERROR: no command given for GetAction()");
						break;
				}
			}
		}
		
		// resolve fighter behavior
		with(owner.fighter)
		{
			// check for attack command, set preliminary target 
			if(is_undefined(_cmd)) || (_cmd.type != "attack")
			{
				attack_target = noone;
			} else {
				attack_target = _cmd.value;
			}

			// attack any enemy in range, but prioritize the attack command target
			if(ds_list_size(enemies_in_range) > 0) 
			{
				// if the attack command target is not in range, then check for any enemies nearby
				if(ds_list_find_index(enemies_in_range, attack_target) == -1){
					// attack closest enemy, or the enemy that attacked this unit recently
					if(instance_exists(retaliation_target))
					{attack_target = retaliation_target} else {attack_target = enemies_in_range[| 0]}
				}
				// give attack command for target if unit is idle
				if(ds_list_size(owner.ai.commands) == 0)
				{
					// if the attack target exists and there is no command currently, give attack command
					if(instance_exists(attack_target))
					{
						with(global.iEngine)
						{
							var _atk_comm = new Command("attack", other.attack_target, other.attack_target.x, other.attack_target.y); 
						}
						ds_list_add(owner.ai.commands, _atk_comm);
					}
				}
			} else {
				// noone to attack but retaliate if applicable, retaliation target is assumed to be noone when not applicable
				attack_target = retaliation_target;
			}

			// attack valid target	
			if(attack_index == -1) && (basic_cooldown_timer <= 0) && (attack_target != noone) && (instance_exists(attack_target))
			{
				owner.attack_direction = point_direction(owner.position[1], owner.position[2], attack_target.position[1], attack_target.position[2]);
				if(ds_list_find_index(enemies_in_range, attack_target) > -1) UseBasic();
			}
		}
	}
	static Destroy = function(){
		// delete commands
		for(var i=0; i<ds_list_size(commands); i++)
		{
			if(!is_undefined(commands[| i])) delete commands[| i];
		}
		// destroy command list
		ds_list_destroy(commands);
	}
}