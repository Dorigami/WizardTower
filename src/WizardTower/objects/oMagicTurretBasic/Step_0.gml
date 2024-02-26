/// @description 

// premature destruction
if(needs_creator && !instance_exists(creator.owner)) || ((--lifetime <= 0))
{
	if(sound_end != snd_empty) SoundCommand(sound_end,x,y);
	destroyed_self = true;
	instance_destroy();
	exit;
}
if(--damage_point_timer == 0) && (instance_exists(creator.owner))
{
	if(sound_damage_point != snd_empty) SoundCommand(sound_damage_point,x,y);
    show_debug_message("damage point - " + object_get_name(object_index));
	var _stats = global.iEngine.actor_list[| faction].fighter_stats[$ "drone"];
	var _len = _stats.collision_radius + other.creator.owner.collision_radius;
	var _dir = other.creator.owner.attack_direction;
	var _x = creator.owner.position[1] + lengthdir_x(_len, _dir);
	var _y = creator.owner.position[2] + lengthdir_y(_len, _dir);
	var _sum = other.creator.owner.structure.supply_current + _stats.supply_cost;
	
	if(other.creator.owner.structure.supply_capacity >= _sum)
	{
		show_debug_message("adding the marine, supply is at: {0}", _sum)
		creator.owner.structure.supply_current = _sum;
		with(instance_create_depth(x,y,-y-1,oMagicBolt))
		{
			ds_list_add(other.creator.owner.structure.units, id);
			creator = other.creator.owner.id;
			xTo = other.creator.owner.structure.rally_x;
			yTo = other.creator.owner.structure.rally_y;
		}
	} else {
		show_debug_message("supply is full, at: {0}", other.creator.owner.structure.supply_current);
	}
}






