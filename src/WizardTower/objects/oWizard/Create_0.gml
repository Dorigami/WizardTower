/// @description init properties

// Inherit the parent event
event_inherited();

// shader stuff
upixelH = shader_get_uniform(shOutline, "pixelH");
upixelW = shader_get_uniform(shOutline, "pixelW");
texelW = texture_get_texel_width(sprite_get_texture(sprite_index,0));
texelH = texture_get_texel_height(sprite_get_texture(sprite_index,0));

PathTicket = function(_units,_startPoint,_endPoint) constructor{
	units = _units;
	startPoint = _startPoint;
	endPoint = _endPoint;
}


selected = false;
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
arrivalSlow = 1;
arrived = false;
destination = -1;
destinationDistance = 0;
target = noone;
path = -1;
pathUpdateDelay = 10;
pathIndex = 0;
pathIndexEnd = 0;
pathDelay = 60;
mySpawner = noone;
spawning = false;

steeringMag = 0.3;
steering = vect2(0,0);
velocity = vect2(0,0);
position = vect2(x,y);

faction = FACTION.PLAYER;



