#macro RESOLUTION_W 1280
#macro RESOLUTION_H 720
#macro FRAME_RATE 60
#macro ROOMSTART rStartMenu
#macro OUT 0
#macro IN 1
#macro MENUDEPTH -7000
#macro UIDEPTH -6500
#macro HUDDEPTH -6000  // hud will indicate user interface that is drawn on the gui layer

enum FACTION
{
	PLAYER0,
	PLAYER1,
	PLAYER2,
	PLAYER3,
	NEUTRAL
}
enum point
{
	x,
	y,
	width,
	length
}
enum STATE
{
	FREE,
	SPAWN,
	INTERACT,
	ATTACK,
	DEAD
}
