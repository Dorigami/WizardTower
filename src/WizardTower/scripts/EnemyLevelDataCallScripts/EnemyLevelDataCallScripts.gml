function level_stop(){
	with(oEnemyLevelData){}
}
function level_start(){
	with(oEnemyLevelData)
	{
		wave_index = -1;
		timeline_index = level_timeline;
		timeline_running = true;
		timeline_position = 0;
		timeline_speed = 1;
		timeline_loop = false;
	}
}