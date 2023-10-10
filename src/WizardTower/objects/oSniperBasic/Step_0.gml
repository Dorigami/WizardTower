/// @description 

// premature destruction
if(needs_creator && !instance_exists(creator.owner)) || ((--lifetime <= 0))
{
	show_debug_message("attack end - " + object_get_name(object_index));
	if(sound_end != snd_empty) SoundCommand(sound_end,x,y);
	destroyed_self = true;
	instance_destroy();
	exit;
}

if(destroyed_self) exit;

if(--damage_point_timer == 0) && (instance_exists(target))
{
	if(sound_damage_point != snd_empty) SoundCommand(sound_damage_point,x,y);
    show_debug_message("damage point - " + object_get_name(object_index));
	creator.DealDamage(attackData.damage_value, target.fighter);
}


