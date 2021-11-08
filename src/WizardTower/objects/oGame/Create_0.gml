/// @description initialize game
Pathfinding();
global.gridSpace = ds_grid_create(GRID_WIDTH, GRID_HEIGHT);

#macro RESOLUTION_W 320
#macro RESOLUTION_H 192
#macro ROOMSTART Room1
#macro GRID_WIDTH 16
#macro GRID_HEIGHT 16
#macro CELL_SIZE 60
#macro FRAME_RATE 60
#macro MENUDEPTH 7777
#macro OUT 0
#macro IN 1
#macro EAST 0
#macro NORTH 1
#macro WEST 2
#macro SOUTH 3
enum PLAYERSTATE 
{
	FREE,
	MOVE,
	SPAWN,
	DEAD,
	FALL,
	STRUCK,
	TOTAL
}
enum ENEMYSTATE
{
	FREE,
	ACT,
	SPAWN,
	DEAD,
	FALL,
	TOTAL
}
enum FACTION
{
	PLAYER,
	NATURE,
	ENEMY,
	NEUTRAL
}
// set up the camera(s)
function InitializeDisplay(){
	//// dynamic resolution
		//ideal_width_ = 0;
		//ideal_height_ = RESOLUTION_H;
		//aspect_ratio_ = display_get_width() / display_get_height();
		//ideal_width_ = round(ideal_height_*aspect_ratio_);
	// static resolution
	ideal_width_ = RESOLUTION_W;
	ideal_height_ = RESOLUTION_H;
	aspect_ratio_ = RESOLUTION_W / RESOLUTION_H;

	//// perfect pixel scaling
		//if(display_get_width() mod ideal_width_ != 0)
		//{
		//	var d = round(display_get_width() / ideal_width_);
		//	ideal_width_ = display_get_width() / d;
		//}
		//if(display_get_height() mod ideal_height_ != 0)
		//{
		//	var d = round(display_get_height() / ideal_height_);
		//	ideal_height_ = display_get_height() / d;
		//}

	//check for odd numbers
	if(ideal_width_ & 1) ideal_width_++;
	if(ideal_height_ & 1) ideal_height_++;

	//do the zoom
	zoom = 3;
	zoom_max_ = floor(display_get_width() / ideal_width_);
	zoom = min(zoom, zoom_max_)
	
	// enable & set views of each room
	for(var i=0; i<=room_last; i++)
	{
		show_debug_message(room_get_name(i)+" has been initialized")
		room_set_view_enabled(i, true);
		room_set_viewport(i,0,true,0,0,ideal_width_, ideal_height_);
	}	
	surface_resize(application_surface, RESOLUTION_W, RESOLUTION_H);
	display_set_gui_size(RESOLUTION_W, RESOLUTION_H);
	window_set_size(RESOLUTION_W*zoom, RESOLUTION_H*zoom);
	alarm[0] = 1;
}

// game setup
global.playerControl = noone;
global.gamePaused = false;
global.playerScore = 0;
global.playerCollected = 0;
global.currentLevel = 0;
global.nextLevel = 1;
global.muteMusic = false;
global.muteSound = false;
global.controller = id;
global.iCamera = instance_create_layer(0,0,"Instances",oCamera);
game_set_speed(FRAME_RATE, gamespeed_fps);
InitializeDisplay();

pathHeap = new NodeHeap();
pathQueue = ds_queue_create();

for(var i=0;i<GRID_WIDTH;i++)
{
for(var j=0;j<GRID_HEIGHT;j++)
{
    global.gridSpace[# i, j] = new GridNode(i ,j);
}
}

room_goto(ROOMSTART);