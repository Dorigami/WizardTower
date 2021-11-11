/// @description 

myNode = global.gridSpace[# x div GRID_WIDTH, y div GRID_HEIGHT];
spawnSpeed = 120;
spawnQueue = ds_queue_create();
spawnHoldPoint = vect2(-50,-50)
queueSize = 5;

repeat(queueSize)
{
	with(instance_create_layer(spawnHoldPoint[1], spawnHoldPoint[2], "Instance", oWizard))
	{
		ds_queue_enqueue(other.spawnQueue, id);
		visible = false;
		spawning = true;
	}
}
