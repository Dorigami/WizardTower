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
		var _stats = -1;
		var _cantplace = place_meeting(x,y,pTower);
		image_blend = _cantplace ? c_red : c_white;
		if(mouse_check_button_released(mb_left)) && (!_cantplace)
		{
			_stats = global.iGame.defaultStats[? towerObj];
			if(global.iGame.playerMoney >= _stats.cost) 
			{
				// pay for the tower
				global.iGame.playerMoney -= _stats.cost;
				instance_create_layer(rect[0], rect[1],"Instances",towerObj, _stats);
				// check if player still has money and check for shift key 
				if(global.iGame.playerMoney < _stats.cost) || (!keyboard_check(vk_shift))
				{
					_cancel = true;
				}
				// check money modifier buff (intel towers only)
				if(towerObj == oTowerIntel) || (towerObj == oTowerSpotter) || (towerObj == oTowerStalker)
				{
					// get adjacent towers and buff them
					var _list = ds_list_create();
					collision_circle_list(x+0.5*TILE_SIZE,y+0.5*TILE_SIZE,TILE_SIZE,pTower,false,true,_list,false);
					if(ds_list_size(_list)>0)
					{
						for(var i=0; i<ds_list_size(_list); i++)
						{
							var _tower = _list[| i];
							var _dir = point_direction(x,y,_tower.x,_tower.y) / 90;
							// only buff towers that are on adjacent tiles (cardinal directions)
							if(_dir-round(_dir) == 0) && (instance_exists(_tower)) && (_tower.moneyMod < _stats.moneyMod)
							{
								_tower.moneyMod = _stats.moneyMod;
							}
						}
					}
					ds_list_destroy(_list);
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