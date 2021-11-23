/// @description 

function NexusStateSpawn(){
	if(stateCheck != state)
	{
		stateCheck = state;
		wait = 0;
		waitDuration = 30;
		buildProgress = 0;
		image_alpha = 0;
	}
	
	image_alpha = min(1, image_alpha+0.04);
	buildProgress = wait/waitDuration;
	
	if(++wait >= waitDuration)
	{
		repeat(queueSize)
		{
			with(instance_create_layer(x, y, "Instances", oWizard))
			{
				ds_queue_enqueue(other.spawnQueue, id);
				direction = 0;
				visible = true;
				active = true;
				mySpawner = other.id;
				position = vect2(x,y);
				MoveCommand(id, myNode.center[1]+CELL_SIZE, myNode.center[2]);
			}
		}	
		state = STATE.FREE;
		image_alpha = 1;
	}
}

// Inherit the parent event
event_inherited();

stateScript[STATE.SPAWN] = NexusStateSpawn;
stateScript[STATE.FREE] = StructureFree;
stateScript[STATE.DEAD] = StructureDead;

spawnSpeed = 80;
spawnQueue = ds_queue_create();
spawnHoldPoint = vect2(0,0);
queueSize = 3;

// setup radial
radialArgs = [[oButtonRadial,sRadialOne,x,y,"",false,radialDebugScript,["1"],radialDebugScript,["1"]],
			  [oButtonRadial,sRadialTwo,x,y,"",false,radialDebugScript,["2"],radialDebugScript,["2"]],
			  [oButtonRadial,sRadialThree,x,y,"",false,radialDebugScript,["3"],radialDebugScript,["3"]],
			  [oButtonRadial,sRadialThree,x,y,"",false,radialDebugScript,["3"],radialDebugScript,["3"]]
			 ];
radialOptions = array_create(array_length(radialArgs),noone);