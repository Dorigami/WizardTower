/// @description 

sound_start = snd_skeleton_attack_basic;
sound_damage_point = snd_empty;
sound_end = snd_empty;

/*
    var _struct = {
        creator : owner.fighter,
        attackData : basic_attack,
        damageScript : DealDamage
    } 
*/





// Inherit the parent event
event_inherited();

damage_point_timer = attackData.damage_point;
lifetime = 20;



