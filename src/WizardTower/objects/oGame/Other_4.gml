/// @description Level Setup on playspace
var _width = display_get_gui_width();
var _height = display_get_gui_height();
global.col = layer_tilemap_get_id(layer_get_id("Col"));
// setup view
with(global.iCamera)
{
	camera_set_view_size(view_camera[0], RESOLUTION_W, RESOLUTION_H);
	xTo = round(0.5*room_width);
	yTo = round(0.5*room_height);
	x = xTo;
	y = yTo;
}

// setup pathing grid building tiles
for(var i=0;i<GRID_WIDTH;i++) {
for(var j=0;j<GRID_HEIGHT;j++) {
	global.gridSpace[# i, j].blocked = tilemap_get(global.col,i,j);
}}

// hud setup
global.onButton = false;
if(room == rTest)
{
	CreateButton(oButtonGeneric,sBtn32x32,10,0.5*_height,"tower",true,-1,-1,NewStructurePlacement,[oTower]);
	CreateButton(oButtonGeneric,sBtn32x32,10,0.6*_height,"wall",true,-1,-1,NewStructurePlacement,[oWall]);
}