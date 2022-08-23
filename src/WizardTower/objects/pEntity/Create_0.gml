/// @description 

z = 0; ;
grav = 0;
face = 0;
gravEnabled = true;
shadowEnabled = false;
shadowScale = 1;
flash = 0;
flashSpeed = 0.04;
uFlash = shader_get_uniform(shWhiteFlash, "flash");
flashShader = shWhiteFlash;
invulnerable = 0;
myNode = global.gridSpace[# x div CELL_SIZE, y div CELL_SIZE];
showBars = false;
faction = FACTION.PLAYER;
/*

// draw variables
// if(sprite_index != -1) && (sprite_index != sHighlight) 
unitSpriteIndex = sprite_index;
sprite_index = sHighlight;
unitImageIndex = 0;


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
