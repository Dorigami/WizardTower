/// @description 
function WallStateSpawn(){
	if(stateCheck != state)
	{
		stateCheck = state;
		buildProgress = 0;
		image_alpha = 0.2;
	}
	
	if(buildProgress >= 1)
	{
		state = STATE.FREE;
		myNode.walkable = true;
		myNode.discomfort += 8*CELL_SIZE;
		image_alpha = 1;
	}
}
// Inherit the parent event
event_inherited();

stateScript[STATE.SPAWN] = WallStateSpawn;
stateScript[STATE.FREE] = StructureFree;
stateScript[STATE.DEAD] = StructureDead;

