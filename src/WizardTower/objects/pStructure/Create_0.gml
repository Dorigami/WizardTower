/// @description 

// Inherit the parent event
event_inherited();

hp = statHealth;
mn = statMana;
buildProgress = 0;

state = STATE.SPAWN;
stateCheck = -1;
stateScript[STATE.SPAWN] = StructureSpawn;
stateScript[STATE.FREE] = StructureFree;
stateScript[STATE.DEAD] = StructureDead;
target = noone;
radialOptions = -1;

/*


hp = statHealth;
rsc1 = statResource1;
rsc2 = statResource2;
hpColor = c_red;
mtlColor = c_green;
ctlColor = c_aqua;

xTo = xstart;
yTo = ystart;

// draw variables
// if(sprite_index != -1) && (sprite_index != sHighlight) 
unitSpriteIndex = sprite_index;
sprite_index = sHighlight;
unitImageIndex = 0;
faction = FACTION.NEUTRAL;
selected = false;
showBars = false;
highlight = false;
size = 80;
drawBeam = false;
drawBeamScript = SalvageBeam;
drawBeamArgs = [0,0,2000,2000, 1];

CalculateSpriteSize();


targetAlt1 = noone;
targetAlt2 = noone;
attackBehavior = -1;
moveBehavior = -1;
