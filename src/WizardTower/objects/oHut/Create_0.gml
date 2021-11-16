/// @description 

// Inherit the parent event
event_inherited();

function HutStateFree(){
	if(stateCheck != state)
	{
		stateCheck = state;
	}
	//set alarm
	if(ds_queue_size(spawnQueue) > 0) && (alarm[9] == -1)
	{
		alarm[9] = spawnSpeed;
	}
}

stateScript[STATE.SPAWN] = StructureSpawn;
stateScript[STATE.FREE] = HutStateFree;
stateScript[STATE.DEAD] = StructureDead;

spawnSpeed = 80;
spawnQueue = ds_queue_create();
spawnHoldPoint = vect2(0,0)
queueSize = 8;

repeat(queueSize)
{
	with(instance_create_layer(spawnHoldPoint[1], spawnHoldPoint[2], "Instances", oWizard))
	{
		ds_queue_enqueue(other.spawnQueue, id);
		visible = false;
		active = false;
		mySpawner = other.id;
	}
}
