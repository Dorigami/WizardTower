function HurtEntity(_source,_target,_damage){
	if(instance_exists(_target))
	{
		with(_target)
		{
			// deal damage
			hp -= _damage;
			// cause a flash
			flash = 1;
			
			//hurt or dead
			show_debug_message("health reduced to " + string(hp))
			if(hp <= 0)
			{
				instance_destroy();
			} 
		}
	}
}