/// @description 


image_alpha = 0;
// enable buttons when a level has loaded
if(room != rStartMenu) && (room != rInit)
{
	fadeIn = true;
	for(var i=0;i<ds_list_size(controlsList);i++)
	{
		controlsList[| i].enabled = true;
	}
} else {
	for(var i=0;i<ds_list_size(controlsList);i++)
	{
		controlsList[| i].enabled = false;
	}
}
// set initial position of the camera
var _y1 = y + RESOLUTION_H-64;
var _y2 = _y1 + 56;
rectPurchase[0] = x + 8;
rectPurchase[1] = _y1;
rectPurchase[2] = rectPurchase[0] + 160;
rectPurchase[3] = _y2;
rectUpgrade[0] = rectPurchase[2] + 1;
rectUpgrade[1] = _y1;
rectUpgrade[2] = rectUpgrade[0] + 180;
rectUpgrade[3] = _y2;
rectInfo[0] = rectUpgrade[2] + 1;
rectInfo[1] = _y1;
rectInfo[2] = rectInfo[0] + 180;
rectInfo[3] = _y2;
rectStart[0] = rectInfo[2] + 1;
rectStart[1] = _y1;
rectStart[2] = rectStart[0] + 100;
rectStart[3] = _y2;

var _startButton = controlsList[| 4];
_startButton.x = (((rectStart[0] + rectStart[2]) div 2) - x) - 0.5*sprite_get_width(_startButton.sprite);
_startButton.y = (RESOLUTION_H-36) - 0.5*sprite_get_height(_startButton.sprite);