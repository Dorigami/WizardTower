/// @description lose focus

if(room == rStartMenu)
{

	var _ind = -1;
	var _menuObject = oStartMenu.id;
	for(var i=0; i<array_length(_menuObject.options); i++)
	{
		if(id == _menuObject.options[i]) _ind = i;
	}
		
	if(_ind != -1) && (_ind == _menuObject.optionFocus)
	{
		focus = true;
	} else {
		focus = false;
	}

} else {
	
	focus = false;
	global.onButton = false;
}