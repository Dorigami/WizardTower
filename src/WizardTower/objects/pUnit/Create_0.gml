/// @description Setup

// shader stuff
upixelH = shader_get_uniform(sh_outline, "pixelH");
upixelW = shader_get_uniform(sh_outline, "pixelW");
texelW = texture_get_texel_width(sprite_get_texture(sprite_index,0));
texelH = texture_get_texel_height(sprite_get_texture(sprite_index,0));

hp = 10;
hpColor = c_red;

xTo = xstart;
yTo = ystart;

// draw variables
// if(sprite_index != -1) && (sprite_index != sHighlight) 
unitSpriteIndex = sprite_index;
sprite_index = sHighlight;
unitImageIndex = 0;
faction = FACTION.NEUTRAL;
selected = false;
highlight = false;
size = 80;
drawBeam = false;
drawBeamScript = SalvageBeam;
drawBeamArgs = [0,0,2000,2000, 1];

CalculateSpriteSize();

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
