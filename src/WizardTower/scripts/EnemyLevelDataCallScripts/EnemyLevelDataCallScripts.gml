function level_stop(){
	with(oEnemyLevelData){}
}
function level_start(){
	with(oEnemyLevelData)
	{
		level_started = true;
		wave_index = 0;
		timeline_index = level_timeline;
		timeline_running = true;
		timeline_position = 0;
	}
}