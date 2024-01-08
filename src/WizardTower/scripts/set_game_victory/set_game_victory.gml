function set_game_victory(){
	if(global.game_state != GameStates.VICTORY)
	{
		show_debug_message("Level Complete !!!!!!!!!!!!!!!");
		// hide the hud
		global.iHUD.Hide();
		// set game state
		global.game_state = GameStates.VICTORY;
		// create the menu
		instance_create_depth(0,0,UPPERTEXDEPTH,oVictoryMenu);
	} else {
		show_debug_message("error: victory state has already been reached");
	}
}