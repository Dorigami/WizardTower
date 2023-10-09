/// @description 

image_angle += 3;


// premature destruction
if(needs_creator && !instance_exists(creator.owner)) || ((--lifetime <= 0))
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
	collision_circle_list(creator.owner.position[1], creator.owner.position[2], aoe_rad*GRID_SIZE, pEntity, false, true,_list,true);
	for(var i=0; i<ds_list_size(_list);i++)
	{
		var _ent = _list[| i];
		if(_ent.faction == ENEMY_FACTION) && (!is_undefined(_ent.fighter))
		{
			creator.DealDamage(attackData.damage_value, _ent.fighter);
		}
	}
	ds_list_destroy(_list);
}
