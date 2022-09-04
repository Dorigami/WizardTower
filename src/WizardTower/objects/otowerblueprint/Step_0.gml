/// @description 
if(!visible) visible = true;
if(!global.gamePaused)
{
	var _cancel = false;
	var _x = (mouse_x div TILE_SIZE)*TILE_SIZE;
	var _y = (mouse_y div TILE_SIZE)*TILE_SIZE;
	x = _x;
	y = _y;
	rect = [_x, _y, _x+TILE_SIZE,_y+TILE_SIZE];
	
	if(towerObj != -1)
	{
		var _stats = global.iGame.defaultStats[? towerObj];
		var _cantplace = place_meeting(x,y,pTower);
		image_blend = _cantplace ? c_red : c_white;
		if(mouse_check_button_pressed(mb_left)) && (!_cantplace)
		{
			if(global.iGame.playerMoney >= _stats.cost) 
			{
				var _stats = global.iGame.defaultStats[? towerObj];
				global.iGame.playerMoney -= _stats.cost;
				instance_create_layer(rect[0], rect[1],"Instances",towerObj, _stats);
				// check if player still has money
				if(global.iGame.playerMoney < _stats.cost) 
				{
					_cancel = true;
				}
			} else { 
				_cancel = true;
			}
		} else if(mouse_check_button_pressed(mb_right))
		{
			_cancel = true;
		}
	}
	if(_cancel) instance_destroy();
}