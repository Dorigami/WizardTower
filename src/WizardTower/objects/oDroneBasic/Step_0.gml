/// @description 

// premature destruction
if(!instance_exists(target)) || (needs_creator && !instance_exists(creator.owner)) || ((--lifetime <= 0))
{
	if(sound_end != snd_empty) SoundCommand(sound_end,x,y);
	destroyed_self = true;
	instance_destroy();
	exit;
}
if(--damage_point_timer == 0)
{
	if(sound_damage_point != snd_empty) SoundCommand(sound_damage_point,x,y);
    show_debug_message("damage point - " + object_get_name(object_index));
	var _list = ds_list_create();
	instance_place_list(creator.owner.position[1], creator.owner.position[2], pEntity);
	creator.DealDamage(attackData.damage_value, target.fighter);
}



