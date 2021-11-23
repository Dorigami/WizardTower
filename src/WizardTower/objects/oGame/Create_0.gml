/// @description 
Pathfinding();
#macro RESOLUTION_W 640
#macro RESOLUTION_H 384
#macro ROOMSTART rStartMenu
#macro GRID_WIDTH 40
#macro GRID_HEIGHT 24
#macro CELL_SIZE 32
#macro FRAME_RATE 32
#macro MENUDEPTH -7777
#macro BUTTONDEPTH -6666
#macro OUT 0
#macro IN 1
#macro EAST 0
#macro NORTH 1
#macro WEST 2
#macro SOUTH 3
enum FACTION
{
	PLAYER,
	NATURE,
	ENEMY
}
enum STATE
{
	SPAWN,
	FREE,
	BUILD,
	GATHER,
	ATTACK,
	DEAD
}
// set up the camera(s)
function InitializeDisplay(){
	//// dynamic resolution
		//idealWidth = 0;
		//idealHeight = RESOLUTION_H;
		//aspect_ratio_ = display_get_width() / display_get_height();
		//idealWidth = round(idealHeight*aspect_ratio_);
	// static resolution
	idealWidth = RESOLUTION_W;
	idealHeight = RESOLUTION_H;
	aspect_ratio_ = RESOLUTION_W / RESOLUTION_H;

	//// perfect pixel scaling
		//if(display_get_width() mod idealWidth != 0)
		//{
		//	var d = round(display_get_width() / idealWidth);
		//	idealWidth = display_get_width() / d;
		//}
		//if(display_get_height() mod idealHeight != 0)
		//{
		//	var d = round(display_get_height() / idealHeight);
		//	idealHeight = display_get_height() / d;
		//}

	//check for odd numbers
	if(idealWidth & 1) idealWidth++;
	if(idealHeight & 1) idealHeight++;

	//do the zoom
	zoom = 2;
	zoomMax = floor(display_get_width() / idealWidth);
	zoom = min(zoom, zoomMax)
	
	// enable & set views of each room
	for(var i=0; i<=100; i++)
	{
		if(!room_exists(i)) break;
		show_debug_message(room_get_name(i)+" has been initialized")
		if(i == 30){show_message("update display initialize, there are too many rooms")}
		room_set_view_enabled(i, true);
		room_set_viewport(i,0,true,0,0,idealWidth, idealHeight);
	}	
	surface_resize(application_surface, RESOLUTION_W, RESOLUTION_H);
	display_set_gui_size(RESOLUTION_W, RESOLUTION_H);
	window_set_size(RESOLUTION_W*zoom, RESOLUTION_H*zoom);
	alarm[0] = 1;
}

// game setup
depth = -9990;
game_set_speed(FRAME_RATE, gamespeed_fps);
InitializeDisplay();
global.onButton = false;
global.gamePaused = false;
global.muteMusic = false;
global.muteSound = false;
global.iGame = id;
global.iCamera = instance_create_layer(0,0,"Instances",oCamera);
global.iPlayer = instance_create_layer(0,0,"Instances",oPlayer);
global.unitSelection = ds_list_create();
global.gridSpace = ds_grid_create(GRID_WIDTH, GRID_HEIGHT);
global.startPoint = vect2(0,0);
global.goalPoint = vect2(0,0);
pathHeap = new NodeHeap();
pathQueue = ds_queue_create();
maxDiscomfort = 6;
for(var i=0;i<GRID_WIDTH;i++)
{
for(var j=0;j<GRID_HEIGHT;j++)
{
	global.gridSpace[# i, j] = new GridNode(i,j);
}
}

room_goto(ROOMSTART);