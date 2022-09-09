/// @description 

// Inherit the parent event
event_inherited();

image_speed = 0.2*(spd);

gridX = x div GRID_WIDTH;
gridY = y div GRID_HEIGHT;
active = true;
selected = false;
dSet = ds_list_create();
iSet = ds_list_create();
dangerMap = array_create(CS_RESOLUTION, 0);
interestMap = array_create(CS_RESOLUTION, 0);
mask = array_create(CS_RESOLUTION, 0);
allMasked = false;
interest = 0;
hpRect = [0,0,0,0];
hpMax = hp;
killed = true;

steeringMag = 0.3;
steering = vect2(0,0);
velocity = vect2(0,0);
position = vect2(x,y);

// must recieve a struct to set stats and path

if(!is_undefined(path)) && (path != -1) && (path_exists(path))
{
	oldnum = -1;
	newnum = -1;
	pathNum = path_get_number(path);
	pathLen = path_get_length(path);
	pathVect = vect2(0,0); // direction that path is currently going
	pathPos = 0; // number from 0 - 1 indicating progress
	pathNode = vect2(path_get_point_x(path,0), path_get_point_y(path,0));
	position[1] = path_get_point_x(path, 0) + irandom(5);
	position[2] = path_get_point_y(path, 0) + irandom(5);
	visible = true;
} else {
	show_debug_message("ERROR: imp create event. path not given at time of creation");
	instance_destroy();
}
