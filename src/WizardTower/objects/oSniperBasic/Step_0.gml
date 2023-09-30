/// @description 

// Inherit the parent event
event_inherited();
if(destroyed_self) exit;

// animate the shot
animation_progress = lifetime / lifetime_max;
xTo = target.position[1];
yTo = target.position[2];
x = lerp(xTo, xstart, max(0, damage_point_timer/damage_point_timer_max));
y = lerp(yTo, ystart, max(0, damage_point_timer/damage_point_timer_max));
depth = -y;
