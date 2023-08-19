#macro ASPECT_RATIO 16/9
#macro RESOLUTION_W 640
#macro RESOLUTION_H 720 // doesnt really do anything, height is calculated based on aspect ratio and width
#macro FRAME_RATE 60
#macro ROOM_START rDebug
#macro EAST 0
#macro NORTH 1
#macro WEST 2
#macro SOUTH 3
#macro NONE -1
#macro OUT 0
#macro IN 1
#macro GRID_SIZE 32
#macro HALF_GRID GRID_SIZE div 2
#macro ENEMY_FACTION 2
#macro PLAYER_FACTION 1
#macro NEUTRAL_FACTION 0
#macro CS_RESOLUTION 8

enum GameStates {
    PAUSE,
    PLAY,
    BUILDING,
    TARGETING,
    VICTORY,
    DEFEAT,
    MAIN_MENU,
    UPGRADE_MENU
}
enum STATE
{
	FREE,
	SPAWN,
	INTERACT,
	ATTACK,
	DEAD
}
enum ENTITY_TAGS
{
	ARMORED,
	LIGHT,
	MAGICAL,
	DETECTOR,
	STEALTHY
}
enum HUDFOCUS
{
	MINIMAP,
	PLAYERDATA,
	ABILITIES
}
enum FLOATTYPE
{
	FLARE,
	LINEAR,
	TICK
}
