function GoToLevel(_level){
	if(!instance_exists(oTransition))
	{
		RoomTransition(TRANS_TYPE.FADE,_level,InitializeGameData, 0.02);
	}
}