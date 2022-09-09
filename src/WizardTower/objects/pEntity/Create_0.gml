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
showBars = false;

// shader stuff
upixelH = shader_get_uniform(shOutline, "pixelH");
upixelW = shader_get_uniform(shOutline, "pixelW");
texelW = texture_get_texel_width(sprite_get_texture(sprite_index,0));
texelH = texture_get_texel_height(sprite_get_texture(sprite_index,0));

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
