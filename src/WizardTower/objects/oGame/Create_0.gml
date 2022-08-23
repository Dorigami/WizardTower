/// @description 
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
#macro CS_RESOLUTION 6

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

GridNode = function(_xCell=0,_yCell=0) constructor
{
    blocked = false; // whether the cell has something built on it
    towersIR = ds_list_create(); // g = discomfort
	parent = undefined;
    cell = vect2(_xCell,_yCell);
    center = vect2(_xCell*CELL_SIZE+0.5*CELL_SIZE, _yCell*CELL_SIZE+0.5*CELL_SIZE);
}

// set up the camera(s)
function InitializeDisplay(){
	//// dynamic CS_RESOLUTION
		//idealWidth = 0;
		//idealHeight = RESOLUTION_H;
		//aspect_ratio_ = display_get_width() / display_get_height();
		//idealWidth = round(idealHeight*aspect_ratio_);
	// static CS_RESOLUTION
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
global.col = layer_tilemap_get_id(layer_get_id("Col"));
menuStack = ds_stack_create();
for(var i=0;i<GRID_WIDTH;i++ ) { 
for(var j=0;j<GRID_HEIGHT;j++) {
	global.gridSpace[# i, j] = new GridNode(i,j);
}}

room_goto(ROOMSTART);

/*
	create a generic room   
	create a static path in the room for mobs to follow

    use the pathfinding tech to make a tower defense game.  enemies will move on a static path with no random level generation. 
    the map will be divided into terrain for tower placement and terrain for enemy movement (these will not overlap).  
    each tower class will have a base level, two specializations to chose, then one upgrade after the specialization. 

    focus tower - precision shots, hits target regardless of crowds. good for large targets 
        sniper - high damage, high cooldown, high range (stealth detect)
        laser - low cooldown, moderate range, low armor pierce, damage increases with sustained fire (targets two enemies)
    pellet tower - shotgun-type shots, all-purpose damage.  projectiles do not pierce (hits the first thing it collides with)
        minigun - low cooldown, moderate range, bullets deviate from target direction
        bomber - moderate cooldown, short range, armor piercing, aoe damage
    sloth tower - slow down nearby enemies
        brittle aura - larger aoe, slow now builds over time and also gives a stacking armor debuff to enemies
        frostbite - slows at the same rate, but also deals small but constant AP damage to affected enemies
    intel tower - adjacent towers yield more money per kill (selling their data on the block chain)
        spotter - adjacent towers will get additional money yield, and also have stealth detect
        stalker - adjacent towers will also have a small armor piercing and damage bonus

    tower stats = {
        damage : 0 // basic damage resisted by armor
        armorpierce : 0 // true damage that ignores armor
        cooldown : 0 // delay between attacks
        range : 0 // distance threashold to attack enemies
		detect : false // ability to see stealth units
		moneyMod : 0 // multiplier to gold income per kill
    }
    unit stats = {
		hp : 0 // damage required to defeat the enemy
        damage : 0 // value that is dealt to player if they are not defeated
		speed : 0 // movement rate 
		armor : 0 // this value is deducted from incoming basic damage
		stealth : false // only towers with detection can attack 
		money : 0 // value awarded to the player when defeated
    }

    have a ui to spawn enemies with the ability to set: group size, armor, health, speed,

	-- algorithm to follow path using context steering --

//--// pUnit create

var _struct = { units will be given a structed when created that will have:
	path : -1,
	hp : 0, 
	damage : 0,
	speed : 0, 
	armor : 0,
	stealth : false, 
	money : 0
}
oldnum = -1;
newnum = -1;
/////////////////////////////////////////////////// path = -1; //////////
pathNum = path_get_number(path);
pathLen = path_get_length(path);
pathVect = vect2(0,0); // direction that path is currently going
pathPos = 0; // number from 0 - 1 indicating progress
pathNode = vect2(path_get_point_x(path,0), path_get_point_y(path,0));

//--//COLOR PALETTE:
	i'll need a a palette of 8 colors
	2 to be used for towers
	2 to be used for enemies
	2 to be used for the terrain
	1 used for accent features and effects
	1 used for the overall background
towerColor1 = make_colour_rgb()
towerColor2 = make_colour_rgb()
enemyColor1 = make_colour_rgb()
enemyColor2 = make_colour_rgb()
terrainColor1 = make_colour_rgb()
terrainColor2 = make_colour_rgb()
accentColor = make_colour_rgb()
bgColor = make_colour_rgb()

SLSO8 PALETTE
#0d2b45 rgb(13,43,69)
#203c56 rgb(32,60,86)
#544e68 rgb(84,78,104)
#8d697a rgb(141,105,122)
#d08159 rgb(208,129,89)
#ffaa5e rgb(255,170,94)
#ffd4a3 rgb(255,212,163)
#ffecd6 rgb(255,236,214)

//--//things I updated:
	oMobSpawner - create event
	pUnit - create event
	oGame - begin step event
	move GridNode struct over to oGame 
		(delete the pathfinding codes)
		(keep context steering codes)

//--// things to work on
	- tower sprites
	- tower mechanics
	- enemy sprites
	- player health / enemy damage
	- player money
	- game UI
	- enemy spawn timeline
*/