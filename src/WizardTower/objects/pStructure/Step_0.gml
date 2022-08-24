/// @description 

if(!global.gamePaused)
{
	myNode = global.gridSpace[# x div TILE_SIZE, y div TILE_SIZE];
	if(stateScript[state] != -1) script_execute(stateScript[state]);
}
