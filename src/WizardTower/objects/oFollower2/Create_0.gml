/// @description init properties

PathTicket = function(_units,_startPoint,_endPoint) constructor{
	units = _units;
	startPoint = _startPoint;
	endPoint = _endPoint;
}

showContext = true;
moveWobble = 0;
moveWobbleSpeed = 0.5;
resolution = 12;
dSet = ds_list_create();
iSet = ds_list_create();
dangerMap = array_create(resolution, 0);
interestMap = array_create(resolution, 0);
mask = array_create(resolution, 0);
allMasked = false;
interest = 0;
myNode = 0;
myDensity = 0;
arrived = false;
goal = -1;
path = -1;
pathIndex = 0;
pathIndexEnd = 0;
pathDelay = 60;
alarm[10] = 1;

steeringMag = 0.2;
steering = vect2(0,0);
velocity = vect2(0,0);
position = vect2(x,y);



speedMax = 8;
