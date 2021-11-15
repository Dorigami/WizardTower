/// @description 

// Inherit the parent event
event_inherited();

hp = statHealth;
mn = statMana;

stateScript[STATE.SPAWN] = UnitSpawn;
stateScript[STATE.FREE] = UnitFree;
stateScript[STATE.DEAD] = UnitDead;
state = STATE.SPAWN;
stateCheck = -1;
wait = 0;
waitDuration = 0;
spawnProgress = 0;

target = noone;
faction = FACTION.ENEMY;
