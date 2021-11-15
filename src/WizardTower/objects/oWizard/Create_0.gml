/// @description init properties

// Inherit the parent event
event_inherited();

// shader stuff
upixelH = shader_get_uniform(shOutline, "pixelH");
upixelW = shader_get_uniform(shOutline, "pixelW");
texelW = texture_get_texel_width(sprite_get_texture(sprite_index,0));
texelH = texture_get_texel_height(sprite_get_texture(sprite_index,0));

PathTicket = function(_units,_startPoint,_endPoint) constructor{
	units = _units;
	startPoint = _startPoint;
	endPoint = _endPoint;
}

stateScript[STATE.SPAWN] = UnitSpawn;
stateScript[STATE.FREE] = UnitFree;
stateScript[STATE.DEAD] = UnitDead;
faction = FACTION.PLAYER;



