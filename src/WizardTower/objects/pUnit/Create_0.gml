/// @description 

// Inherit the parent event
event_inherited();

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

steeringMag = 0.3;
steering = vect2(0,0);
velocity = vect2(0,0);
position = vect2(x,y);

// shader stuff
upixelH = shader_get_uniform(shOutline, "pixelH");
upixelW = shader_get_uniform(shOutline, "pixelW");
texelW = texture_get_texel_width(sprite_get_texture(sprite_index,0));
texelH = texture_get_texel_height(sprite_get_texture(sprite_index,0));

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
