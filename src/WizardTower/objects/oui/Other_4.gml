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
var _y2 = _y1 + 55;
rectPurchase[0] = x + 8;
rectPurchase[1] = _y1;
rectPurchase[2] = rectPurchase[0] + 200;
rectPurchase[3] = _y2;
rectUpgrade[0] = rectPurchase[2] + 1;
rectUpgrade[1] = _y1;
rectUpgrade[2] = rectUpgrade[0] + 110;
rectUpgrade[3] = _y2;
rectInfo[0] = rectUpgrade[2] + 1;
rectInfo[1] = _y1;
rectInfo[2] = rectInfo[0] + 190;
rectInfo[3] = _y2;
rectStart[0] = rectInfo[2] + 1;
rectStart[1] = _y1;
rectStart[2] = rectStart[0] + 120;
rectStart[3] = _y2;

// move wave start button
var _btn = controlsList[| 4];
_btn.x = (((rectStart[0] + rectStart[2]) div 2) - x) - 0.5*sprite_get_width(_btn.sprite);
_btn.y = (RESOLUTION_H-36) - 0.5*sprite_get_height(_btn.sprite);

// move the upgrade buttons
var _x,_y;
var _hsep = 4;
var _vsep = 1;
var _center = [0.5*(rectUpgrade[2]+rectUpgrade[0]), 0.5*(rectUpgrade[3]+rectUpgrade[1])];
// move the upgrade buttons
_btn = controlsList[| 5];
_btn.x = (_center[0]-_hsep-sprite_get_width(_btn.sprite)) - x;
_btn.y = (_center[1]-_vsep-sprite_get_height(_btn.sprite)) - y;

_btn = controlsList[| 6];
_btn.x = _center[0]+_hsep-x;
_btn.y = (_center[1]-_vsep-sprite_get_height(_btn.sprite)) - y;

_btn = controlsList[| 7];
_btn.x = _center[0]-_hsep-sprite_get_width(_btn.sprite) - x;
_btn.y = _center[1]+_vsep-y;

_btn = controlsList[| 8];
_btn.x = _center[0]+_hsep-x;
_btn.y = _center[1]+_vsep-y;
// disable upgrade buttons
for(var i=5;i<=8;i++) 
{
	_btn = controlsList[| i]; 
	_btn.enabled = false;
}