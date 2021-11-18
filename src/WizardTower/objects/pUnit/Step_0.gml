/// @description 
if(!active) exit;
if(!global.gamePaused)
{
	myNode = global.gridSpace[# x div CELL_SIZE, y div CELL_SIZE];
	if(stateScript[state] != -1) script_execute(stateScript[state]);
}

