/// @description 



// Inherit the parent event
event_inherited();

needs_creator = true;
lifetime = floor(attackData.duration*FRAME_RATE);
lifetime_max = lifetime;
damage_point_timer = floor(lifetime*0.75);
damage_point_timer_max = damage_point_timer;

