/// @description 

sound_start = snd_summoner_attack;
sound_damage_point = snd_empty;
sound_end = snd_empty;



// Inherit the parent event
event_inherited();

needs_creator = true;
if(!instance_exists(creator.owner)) || (!instance_exists(target))
{
	instance_destroy();
	exit;
}

// stop floating
creator.owner.float_enabled = false;

// variables to handle animation
xstart = creator.owner.position[1];
ystart = creator.owner.position[2];
xend = target.position[1];
yend = target.position[2];
zstart = creator.owner.z;
zVel = 6;
zDelta = 2*(zstart-zVel*damage_point_timer_max)/power(damage_point_timer_max,2);
progress = 0;
progressSpeed = power(damage_point_timer_max,-1);

