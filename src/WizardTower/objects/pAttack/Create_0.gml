/// @description 

/*
    var _struct = {
        creator : owner.fighter,
        attackData : basic_attack,
		target : attack_target,
        damageScript : DealDamage
    } 
*/

destroyed_self = false;
needs_creator = false;
damage_point_timer = attackData.damage_point;
damage_point_timer_max = damage_point_timer;
lifetime = damage_point_timer+1;
lifetime_max = lifetime;
animation_progress = 0;
xTo = 0;
yTo = 0;


if(sound_start != snd_empty) SoundCommand(sound_start,x,y);