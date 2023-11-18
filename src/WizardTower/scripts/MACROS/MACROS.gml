#macro ASPECT_RATIO 16/9
#macro RESOLUTION_W 640
#macro RESOLUTION_H 720 // doesnt really do anything, height is calculated based on aspect ratio and width
#macro CANVAS_W sprite_get_width(sShaderCanvas)
#macro CANVAS_H sprite_get_height(sShaderCanvas)
#macro FRAME_RATE 60
#macro ROOM_START rShaderTest
#macro UPPERTEXDEPTH -4000
#macro LOWERTEXDEPTH 100
#macro EAST 0
#macro NORTH 1
#macro WEST 2
#macro SOUTH 3
#macro NONE -1
#macro OUT 0
#macro IN 1
#macro KEY 0
#macro VAL 1
#macro GRID_SIZE 32
#macro HALF_GRID GRID_SIZE div 2
#macro ENEMY_FACTION 2
#macro PLAYER_FACTION 1
#macro NEUTRAL_FACTION 0
#macro CS_RESOLUTION 8
// entity types
#macro UNIT 0
#macro STRUCTURE 1

enum GameStates {
    PAUSE,
    PLAY,
    BUILDING,
	SELLING,
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
