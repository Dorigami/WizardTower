/// @description 
#macro RESOLUTION_W 640
#macro RESOLUTION_H 384
#macro ROOMSTART rStartMenu
#macro GRID_WIDTH 40
#macro GRID_HEIGHT 24
#macro TILE_SIZE 32
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

GridNode = function(_xCell=0,_yCell=0) constructor
{
    blocked = false; // whether the cell has something built on it
    towersIR = ds_list_create(); // g = discomfort
	parent = undefined;
    cell = vect2(_xCell,_yCell);
    center = vect2(_xCell*TILE_SIZE+0.5*TILE_SIZE, _yCell*TILE_SIZE+0.5*TILE_SIZE);
}

// set up the camera(s)/display
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
		room_set_width(i,RESOLUTION_W + 2*TILE_SIZE);
		room_set_height(i,RESOLUTION_H + 2*TILE_SIZE);
	}	
	surface_resize(application_surface, RESOLUTION_W, RESOLUTION_H);
	display_set_gui_size(RESOLUTION_W, RESOLUTION_H);
	window_set_size(RESOLUTION_W*zoom, RESOLUTION_H*zoom);
	alarm[0] = 1;
}

color0 = make_colour_rgb(13,43,69);
color1 = make_colour_rgb(32,60,86);
color2 = make_colour_rgb(84,78,104);
color3 = make_colour_rgb(141,105,122);
color4 = make_colour_rgb(208,129,89);
color5 = make_colour_rgb(255,170,94);
color6 = make_colour_rgb(255,212,163);
color7 = make_colour_rgb(255,236,214);

playerHealth = 100;
playerMoney = 200;
menuStack = ds_stack_create();
spawnerMemory = {
	path : pathMob0,
	type : 0,
	groupSize : 8,
	hp : 3,
	damage : 1,
	spd : 1,
	armor : 0,
	stealth : 0,
	money : 10
}

path = -1;
type = 0;
groupSize = 0;
hp = 0;
damage = 0;
spd = 0;
armor = 0;
stealth = 0;
money = 0;
// game setup
depth = MENUDEPTH;
game_set_speed(FRAME_RATE, gamespeed_fps);
InitializeDisplay();
global.gamePaused = false;
global.muteMusic = false;
global.muteSound = false;
global.iGame = id;
global.iCamera = instance_create_layer(0,0,"Instances",oCamera);
global.iPlayer = instance_create_layer(0,0,"Instances",oPlayer);
global.iUI = instance_create_layer(0,0,"Instances",oUI);
global.unitSelection = ds_list_create();
global.gridSpace = ds_grid_create(GRID_WIDTH, GRID_HEIGHT);
global.startPoint = vect2(0,0);
global.goalPoint = vect2(0,0);
global.col = layer_tilemap_get_id(layer_get_id("Col"));
global.mobPaths = [pathMob0, pathMob1, pathMob2, pathMob3, pathMob4, pathMob5];
for(var i=0;i<GRID_WIDTH;i++ ) { 
for(var j=0;j<GRID_HEIGHT;j++) {
	global.gridSpace[# i, j] = new GridNode(i,j);
}}

// array of stucts used to spawn specific waves at indicated moments
stageData = undefined;

// array of stucts used to initialize the timeline
tl = timeline_add();
tlmoment = -1; // current moment in the timeline
tlmap = ds_map_create(); // this map will store lists that will store structs containing spawn information.  the 'key' will correspond to the timeline moment where the spawning will take place
timeline_index = tl;


// setup a map to store the default tower stats
arrEnemies = [
	oUnitGrunt,
	oUnitBrute,
	oUnitGolem,
	oUnitFiend,
	oUnitTransport
];
defaultStats = ds_map_create();

//--// towers
var _pellet = { name : "Pellet",cost : 1, damage : 1, armorpierce : 1, cooldown : 0.5,
		        range : 3, detect : false, moneyMod : 1 }
				ds_map_add(defaultStats, oTowerPellet, _pellet);
	
var _minigun = { name : "Minigun",cost : 5, damage : 1, armorpierce : 1, cooldown : 1,
		            range : 1, detect : false, moneyMod : 1 }
					ds_map_add(defaultStats, oTowerMinigun, _minigun);
	
var _bomber = { name : "Bomber",cost : 5, damage : 1, armorpierce : 1, cooldown : 1,
		        range : 1, detect : false, moneyMod : 1 }
				ds_map_add(defaultStats, oTowerBomber, _bomber);

var _bolt = { name : "Bolt",cost : 2, damage : 2, armorpierce : 1, cooldown : 1,
		        range : 4, detect : false, moneyMod : 1 }
				ds_map_add(defaultStats, oTowerBolt, _bolt);

var _sniper = { name : "Sniper",cost : 5, damage : 1, armorpierce : 1, cooldown : 1,
		        range : 1, detect : true, moneyMod : 1 }
				ds_map_add(defaultStats, oTowerSniper, _sniper);
	
var _laser = { name : "Laser",cost : 5, damage : 1, armorpierce : 1, cooldown : 1,
		        range : 1, detect : false, moneyMod : 1 }
				ds_map_add(defaultStats, oTowerLaser, _laser);

var _ice = { name : "Ice",cost : 3, damage : 3, armorpierce : 1, cooldown : 1,
		        range : 2, detect : false, moneyMod : 1 }
				ds_map_add(defaultStats, oTowerIce, _ice);

var _brittle = { name : "Brittle",cost : 5, damage : 1, armorpierce : 1, cooldown : 1,
		            range : 1, detect : false, moneyMod : 1 }
					ds_map_add(defaultStats, oTowerBrittle, _brittle);

var _frost = { name : "Frostbite",cost : 5, damage : 1, armorpierce : 1, cooldown : 1,
		        range : 1, detect : false, moneyMod : 1 }
				ds_map_add(defaultStats, oTowerFrost, _frost);

var _intel = { name : "Intel",cost : 4, damage : 1, armorpierce : 1, cooldown : 1,
		        range : 1, detect : false, moneyMod : 1.2 }
				ds_map_add(defaultStats, oTowerIntel, _intel);

var _spotter = { name : "Spotter",cost : 5, damage : 1, armorpierce : 1, cooldown : 1,
		            range : 1, detect : true, moneyMod : 1.2 }
					ds_map_add(defaultStats, oTowerSpotter, _spotter);

var _stalker = { name : "Stalker",cost : 5, damage : 1, armorpierce : 1, cooldown : 1,
		            range : 1, detect : true, moneyMod : 1.2 }
					ds_map_add(defaultStats, oTowerStalker, _stalker);
//--// enemies
// - grunt (basic unit, high numbers)
// - brute (small numbers, high health)
// - golem (small numbers, high armor)
// - fiend (fast, but low health)
// - transport (armored, slow, spawns grunts when killed)
var _grunt = {name : "Grunt",path : -1,type : 0,hp : 4,damage : 1,spd : 2,armor : 1,stealth : 0,money : 5}
				ds_map_add(defaultStats, oUnitGrunt, _grunt);
	
var _brute = {name : "Brute",path : -1,type : 1,hp : 8,damage : 1,spd : 1,armor : 2,stealth : 0,money : 25}
					ds_map_add(defaultStats, oUnitBrute, _brute);
	
var _golem = {name : "Golem",path : -1,type : 2,hp : 10,damage : 1,spd : 1,armor : 10,stealth : 0,money : 25}
				ds_map_add(defaultStats, oUnitGolem, _golem);

var _fiend = {name : "Fiend",path : -1,type : 3,hp : 2,damage : 1,spd : 3,armor : 0,stealth : 0,money : 10}
				ds_map_add(defaultStats, oUnitFiend, _fiend);

var _transport = {name : "Transport",path : -1,type : 4,hp : 6,damage : 1,spd : 1.5,armor : 4,stealth : 0,money : 15}
				ds_map_add(defaultStats, oUnitTransport, _transport);

room_goto(ROOMSTART);

/*
	This game will have a cyberspace-pixelart style.  the enemies should resemble viruses, the terrain should look like a circuit/pcb or maybe just a minimalist pixely walkway (makeing it look like some environment within a computer's logic)
	
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


//--//COLOR PALETTE:

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
	
//--// things to work on
	- define modifiers for waves to give enemies stealth, extra armor, etc...
	- find/create a tileset for the terrain & paths
	- tower sprites
	- tower mechanics (add a kill count for individual towers)
	- enemy sprites
	- player health / enemy damage
	- game UI
	- music
		- startmenu jingle
		- stage 1 track
	- sound effects
		- sndButtonClick
		- sndStageVictory
		- sndStageDefeat
		- sndGruntHurt
		- sndGruntKill
		- sndGruntAttack
		- sndBruteHurt
		- sndBruteKill
		- sndBruteAttack
		- sndGolemHurt
		- sndGolemKill
		- sndGolemAttack
		- sndFiendHurt
		- sndFiendKill
		- sndFiendAttack
		- sndTransportHurt
		- sndTransportKill
		- sndTransportAttack
		- sndTowerBuilt
		- sndTowerSold
		- sndTowerUpgrade
		- sndShootPellet
		- sndShootMinigun
		- sndShootBomber
		- sndShootBolt
		- sndShootSniper
		- sndShootLaser
		- sndShootIce
		- sndShootBrittle
		- sndShootFrostbite
		- sndShootIntel
		- sndShootSpotter
		- sndShootStalker
	- animations
		- sGrunt
		- sGruntDie
		- sBrute
		- sBruteDie
		- sGolem
		- sGolemDie
		- sFiend
		- sFiendDie
		- sTransport
		- sTransportDie
        - sTowerPelletIdle
		- sTowerPelletShoot
        - sTowerMinigunIdle
		- sTowerMinigunShoot
        - sTowerBomberIdle
		- sTowerBomberShoot
        - sTowerBoltIdle
		- sTowerBoltShoot
        - sTowerSniperIdle
		- sTowerSniperShoot
        - sTowerLaserIdle
		- sTowerLaserShoot
        - sTowerIceIdle
		- sTowerIceShoot
        - sTowerBrittleIdle
		- sTowerBrittleShoot
        - sTowerFrostIdle
		- sTowerFrostShoot
        - sTowerIntelIdle
		- sTowerIntelShoot
        - sTowerSpotterIdle
		- sTowerSpotterShoot
        - sTowerStalkerIdle
		- sTowerStalkerShoot
		- sBtnPause
		- sBtnResetCamera
		- sBtnMuteSound
		- sBtnMuteMusic
		- sBtnBuyItem

	- add a ui button to start next wave early, this will buf the units' money yield for that wave

	

*/

