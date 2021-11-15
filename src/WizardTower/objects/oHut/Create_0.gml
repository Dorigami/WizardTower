/// @description 

// Inherit the parent event
event_inherited();

function HutStateFree(){
	if(stateCheck != state)
	{
		stateCheck = state;
		speed = 0;
	}
	//set alarm
	if(ds_queue_size(spawnQueue) > 0) && (alarm[0] == -1)
	{
		alarm[0] = spawnSpeed;
	}
}

stateScript[STATE.SPAWN] = StructureSpawn;
stateScript[STATE.FREE] = HutStateFree;
stateScript[STATE.DEAD] = StructureDead;

spawnSpeed = 120;
spawnQueue = ds_queue_create();
spawnHoldPoint = vect2(-50,-50)
queueSize = 5;

repeat(queueSize)
{
	with(instance_create_layer(spawnHoldPoint[1], spawnHoldPoint[2], "Instances", oWizard))
	{
		ds_queue_enqueue(other.spawnQueue, id);
		visible = false;
		mySpawner = other.id;
	}
}
