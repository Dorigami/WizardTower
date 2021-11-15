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
faction = FACTION.ENEMY;

target = noone;
selected = false;
resolution = 12;
dSet = ds_list_create();
iSet = ds_list_create();
dangerMap = array_create(resolution, 0);
interestMap = array_create(resolution, 0);
mask = array_create(resolution, 0);
allMasked = false;
interest = 0;
arrivalSlow = 1;
arrived = false;
destination = -1;
destinationDistance = 0;
target = noone;
path = -1;
pathUpdateDelay = 15;
pathIndex = 0;
pathIndexEnd = 0;
mySpawner = noone;

steeringMag = 0.3;
steering = vect2(0,0);
velocity = vect2(0,0);
position = vect2(x,y);