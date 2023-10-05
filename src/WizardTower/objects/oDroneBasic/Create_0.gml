/// @description 

sound_start = snd_summoner_attack;
sound_damage_point = snd_empty;
sound_end = snd_empty;



// Inherit the parent event
event_inherited();

needs_creator = true;
if(!instance_exists(creator.owner))
{
	instance_destroy();
	exit;
}

// variables to handle animation
xstart = creator.owner.position[1];
ystart = creator.owner.position[2];
zstart = creator.owner.z;
zVel = 0;
zDelta = 1.4;
progress = 0;
progressSpeed = 0.08;

