/// @description 

//set alarm
if(ds_queue_size(spawnQueue) > 0) && (alarm[0] == -1)
{
	alarm[0] = spawnSpeed;
}
