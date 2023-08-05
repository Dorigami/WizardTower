/// @description 


if(--lifetime <= 0)
{
    show_debug_message("end of life - " + object_get_name(object_index));
    instance_destroy();
}

if(!variable_struct_exists(creator, "faction")) { instance_destroy(); exit; }

if(--damage_point_timer == 0) && (instance_exists(creator.attack_target))
{
    show_debug_message("damage point - " + object_get_name(object_index));
	with(creator)
	{
		DealDamage(other.attackData.damage_value, attack_target);
	}
}