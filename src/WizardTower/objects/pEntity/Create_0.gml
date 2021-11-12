/// @description 

// draw variables
// if(sprite_index != -1) && (sprite_index != sHighlight) 
unitSpriteIndex = sprite_index;
sprite_index = sHighlight;
unitImageIndex = 0;
faction = FACTION.NEUTRAL;
selected = false;

// command variables
state = STATE.FREE;
stateCheck = state;
stateScript[STATE.SPAWN] = UnitSpawn;
stateScript[STATE.FREE] = UnitFree;
stateScript[STATE.INTERACT] = UnitInteract;
stateScript[STATE.ATTACK] = UnitAttack;
stateScript[STATE.DEAD] = UnitDead;
target = noone;
targetAlt1 = noone;
targetAlt2 = noone;
attackBehavior = -1;
moveBehavior = -1;
