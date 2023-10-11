/// @description 

sound_start = snd_summoner_attack;
sound_damage_point = snd_mortar_end;
sound_end = snd_empty;




// Inherit the parent event
event_inherited();

lifetime += 150;

spr_start = s_mortar_shot_start;
spr_end = s_mortar_shot_end;

var _dir = 10*irandom(36);
var _len = irandom(35);
xend = creator.owner.structure.rally_x+lengthdir_x(_len,_dir);
yend = creator.owner.structure.rally_y+lengthdir_y(_len,_dir);
image_number_start = sprite_get_number(spr_start);
image_number_end = sprite_get_number(spr_end);

var _scale = 1;
image_xscale = _scale;
image_yscale = _scale;
x = creator.owner.position[1];
y = creator.owner.position[2]-10;
depth = UPPERTEXDEPTH;
visible = true;
image_speed = 0.5;
image_angle = 0;

aoe_rad = 30;
end_scale = aoe_rad / sprite_get_width(spr_end);

