/// @description 

if(!instance_exists(creator)) || (!instance_exists(target))
{
	instance_destroy();
	exit;
}

var _x1 = creator.x;
var _y1 = creator.y;
var _x2 = target.x;
var _y2 = target.y;

progress += progressSpeed;
zVel += zDelta;
z = z+zVel;
if(progress >= 1) 
{
	HurtEntity(creator.id,target.id,damage);
	instance_destroy();
}
xprevious = x;
yprevious = y;
x = _x1+progress*(_x2-_x1);
y =	_y1+progress*(_y2-_y1) + z;

image_angle = point_direction(xprevious, yprevious,x,y);
if(image_xscale < 1) image_xscale = min(image_xscale+scaleRate, 1);