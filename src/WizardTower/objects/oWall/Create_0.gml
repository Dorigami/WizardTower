/// @description 
function WallStateSpawn(){
	if(stateCheck != state)
	{
		stateCheck = state;
		buildProgress = 0;
		image_alpha = 0.2;
	}
	
	var _size = ds_list_size(builderList);
	if(_size > 0)
	{
		var _offset = 0;
		for(var i=0;i<_size;i++)
		{
			if(!instance_exists(builderList[| i-_offset])) || (builderList[| i-_offset].state != STATE.BUILD)
			{
				//ignore units that stop building
				ds_list_delete(builderList, i-_offset);
				_offset++;
				_size--;
			}
		}
		if(_size > 0) buildProgress = min(1, buildProgress + (0.9+0.1*_size)*(1/(statBuildTime*FRAME_RATE)));
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

