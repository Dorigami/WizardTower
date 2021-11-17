/// @description 

// Inherit the parent event
event_inherited();

function SpawnCrystalSpawn(){
	if(stateCheck != state)
	{
		stateCheck = state;
		spawnProgress = 0;
		wait = 0;
		waitDuration = 30;
		flash = flashSpeed*waitDuration;
		image_alpha = 0;
	}

	image_alpha = min(1, image_alpha+0.04);
	spawnProgress = wait/waitDuration;

	if(++wait >= waitDuration)
	{
		state = STATE.FREE;
	}
}

stateScript[STATE.SPAWN] = SpawnCrystalSpawn;
stateScript[STATE.FREE] = StructureFree;
stateScript[STATE.ATTACK] = StructureFree;
stateScript[STATE.BUILD] = -1;
stateScript[STATE.GATHER] = -1;
stateScript[STATE.DEAD] = StructureDead;