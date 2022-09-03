/// @description Initialize UI

// Inherit the parent event
event_inherited();
// UI functions
	

cam = view_camera[0];
viewWidthHalf = 0.5*camera_get_view_width(cam);
viewHeightHalf = 0.5*camera_get_view_height(cam);
fadeIn = false;

image_alpha = 0;
image_xscale = RESOLUTION_W / sprite_width;
image_yscale = RESOLUTION_H / sprite_height;
// show_debug_message("xscale = " + string(image_xscale) + "\nyscale = " + string(image_yscale));

function BuyTower(_obj){
    var _stats = global.iGame.defaultStats[? _obj];
	var _struct = {
		towerObj : _obj
	}
	
	// remove existing blueprints
	with(oTowerBlueprint) instance_destroy();
	
	// create blueprint if player has enough money
    if(global.iGame.playerMoney >= _stats.cost)
    {
		instance_create_layer(
		(mouse_x div TILE_SIZE)*TILE_SIZE,
		(mouse_y div TILE_SIZE)*TILE_SIZE,
		"Instances",
		oTowerBlueprint,
		_struct
		);
    }
}
function StartStage(){
	show_debug_message("stage starting");
	with(global.iGame)
	{
		if(!timeline_running)
		{
			timeline_position = 0;
			timeline_running = true;
		}
	}
}

var _control = undefined;
var _x = x+16;
var _y = y+340;

// purchase pellet tower
_control = ButtonAdd(_x,_y,id,ds_list_size(controlsList),"buypellet",sBtnAction,,"Plt",ord("Z"),BuyTower,[oTowerPellet]);
// purchase the bolt tower
_x += 33; _y += 0;
_control = ButtonAdd(_x,_y,id,ds_list_size(controlsList),"buybolt",sBtnAction,,"Blt",ord("X"),BuyTower,[oTowerBolt]);
// puchase the ice tower
_x += 33; _y += 0;
_control = ButtonAdd(_x,_y,id,ds_list_size(controlsList),"buyice",sBtnAction,,"Ice",ord("C"),BuyTower,[oTowerIce]);
// purchase the intel tower
_x += 33; _y += 0;
_control = ButtonAdd(_x,_y,id,ds_list_size(controlsList),"buyintel",sBtnAction,,"Int",ord("V"),BuyTower,[oTowerIntel]);
// start stage
_x += 400; _y += 0;
_control = ButtonAdd(_x,_y,id,ds_list_size(controlsList),"startstage",sBtnAction,,"start",vk_enter,StartStage,-1);


