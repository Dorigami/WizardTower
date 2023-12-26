/// @description 
if(timeline_exists(wave_timeline))
{
	timeline_running = false;
	timeline_delete(wave_timeline);
}
ds_list_destroy(entity_list);
ds_list_destroy(spawner_list);
