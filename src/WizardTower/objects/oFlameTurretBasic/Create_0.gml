/// @description 

sound_start = snd_summoner_attack;
sound_damage_point = snd_empty;
sound_end = snd_empty;



depth = LOWERTEXDEPTH;
sprite_index = sFlameTurretAttack;
image_speed = 0.2;
image_alpha = 0.3;

// Inherit the parent event
event_inherited();

needs_creator = true;
if(!instance_exists(creator.owner))
{
	instance_destroy();
	exit;
}

lifetime += 100;
aoe_rad = creator.range;

image_xscale = 2.5*creator.range*GRID_SIZE/sprite_get_width(sprite_index);
image_yscale = image_xscale;
visible = true;

show_debug_message("the scale is = {0}", image_xscale);

