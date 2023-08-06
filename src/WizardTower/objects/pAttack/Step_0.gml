/// @description 

// premature destruction
if(!instance_exists(target)) || (needs_creator && !instance_exists(creator.owner)) || ((--lifetime <= 0))
{
	destroyed_self = true;
	instance_destroy();
	exit;
}
if(--damage_point_timer == 0)
{
    show_debug_message("damage point - " + object_get_name(object_index));
	creator.DealDamage(attackData.damage_value, target.fighter);
}
