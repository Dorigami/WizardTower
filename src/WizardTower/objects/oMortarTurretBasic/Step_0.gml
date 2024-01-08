/// @description 

// premature destruction
if(needs_creator && !instance_exists(creator.owner)) || ((--lifetime <= 0))
{
	// show_debug_message("attack end - " + object_get_name(object_index));
	if(sound_end != snd_empty) SoundCommand(sound_end,x,y);
	destroyed_self = true;
	instance_destroy();
	exit;
}

if(destroyed_self) exit;

if(--damage_point_timer == 0)
{
	image_index = 0;
	if(sound_damage_point != snd_empty) SoundCommand(sound_damage_point,x,y);
    // show_debug_message("damage point - " + object_get_name(object_index));
	var _list = ds_list_create();
	if(collision_circle_list(xend, yend, aoe_rad, pEntity, false, true, _list, true) > 0)
	{
		for(var i=0; i<ds_list_size(_list);i++)
		{
			var _ent = _list[| i];
			if(_ent.faction == ENEMY_FACTION) && (!is_undefined(_ent.fighter))
			{
				creator.DealDamage(attackData.damage_value, _ent.fighter);
			}
		}
	}
	ds_list_destroy(_list);
	lifetime = 60;
}
