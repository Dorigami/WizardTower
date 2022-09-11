/// @description Initialize UI

// Inherit the parent event
event_inherited();
// UI functions
	

cam = view_camera[0];
viewWidthHalf = 0.5*camera_get_view_width(cam);
viewHeightHalf = 0.5*camera_get_view_height(cam);
yMenu = RESOLUTION_H-72;
fadeIn = false;
targetClick = false;
targetHover = noone;
targetHoverCheck = noone;
rectPurchase = [0,0,0,0];
rectUpgrade = [0,0,0,0];
rectInfo = [0,0,0,0];
rectStart = [0,0,0,0];

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
		if(!timeline_running) && (!is_undefined(stageData))
		{
			timeline_position = 0;
			timeline_running = true;
		}
	}
}
function UpdateUpgradeButtons(){
	var _btn = noone;
	// clear the upgrade buttons
	for(var i=5;i<=8;i++) { _btn = controlsList[| i]; _btn.enabled = false; _btn.caption = "---"; }

	if((instance_exists(targetHover)) && (object_get_parent(targetHover)) != pUnit)
	{
		var _obj = targetHover.object_index;
		var _upgraded = string_pos("+",targetHover.name) > 0;

		if(_obj == oTowerPellet) || (_obj == oTowerMinigun) || (_obj == oTowerBomber){
			// Pellet-line of Upgrades
			_btn = controlsList[| 5];
			_btn.caption = "mng1";
			_btn.activationScriptArgs = [0];
			_btn = controlsList[| 6];
			_btn.caption = "mng2";
			_btn.activationScriptArgs = [8];
			_btn = controlsList[| 7];
			_btn.caption = "bom1";
			_btn.activationScriptArgs = [1];
			_btn = controlsList[| 8];
			_btn.caption = "bom2";
			_btn.activationScriptArgs = [9];
		} else if(_obj == oTowerBolt) || (_obj == oTowerSniper) || (_obj == oTowerLaser){
			// Bolt-line of Upgrades
			_btn = controlsList[| 5];
			_btn.caption = "spr1";
			_btn.activationScriptArgs = [2];
			_btn = controlsList[| 6];
			_btn.caption = "spr2";
			_btn.activationScriptArgs = [10];
			_btn = controlsList[| 7];
			_btn.caption = "lsr1";
			_btn.activationScriptArgs = [3];
			_btn = controlsList[| 8];
			_btn.caption = "lsr2";
			_btn.activationScriptArgs = [11];
		} else if(_obj == oTowerIce) || (_obj == oTowerBrittle) || (_obj == oTowerFrost){
			// Ice-line of Upgrades
			_btn = controlsList[| 5];
			_btn.caption = "brt1";
			_btn.activationScriptArgs = [4];
			_btn = controlsList[| 6];
			_btn.caption = "brt2";
			_btn.activationScriptArgs = [12];
			_btn = controlsList[| 7];
			_btn.caption = "fst1";
			_btn.activationScriptArgs = [5];
			_btn = controlsList[| 8];
			_btn.caption = "fst2";
			_btn.activationScriptArgs = [13];
		} else if(_obj == oTowerIntel) || (_obj == oTowerSpotter) || (_obj == oTowerStalker){
			// Intel-line of Upgrades
			_btn = controlsList[| 5];
			_btn.caption = "spt1";
			_btn.activationScriptArgs = [6];
			_btn = controlsList[| 6];
			_btn.caption = "spt2";
			_btn.activationScriptArgs = [14];
			_btn = controlsList[| 7];
			_btn.caption = "stk1";
			_btn.activationScriptArgs = [7];
			_btn = controlsList[| 8];
			_btn.caption = "stk2";
			_btn.activationScriptArgs = [15];
		}
		// enable the buttons
		if(_obj == oTowerPellet) || (_obj == oTowerBolt) || (_obj == oTowerIce) || (_obj == oTowerIntel)
		{
			controlsList[| 5].enabled = true;
			controlsList[| 6].enabled = false;
			controlsList[| 7].enabled = true;
			controlsList[| 8].enabled = false;
		} else if(_obj == oTowerMinigun) || (_obj == oTowerSniper) || (_obj == oTowerBrittle) || (_obj == oTowerSpotter){
			controlsList[| 5].enabled = false;
			controlsList[| 6].enabled = true;
			controlsList[| 7].enabled = false;
			controlsList[| 8].enabled = false;
		} else if(_obj == oTowerBomber) || (_obj == oTowerLaser) || (_obj == oTowerFrost) || (_obj == oTowerStalker){
			controlsList[| 5].enabled = false;
			controlsList[| 6].enabled = false;
			controlsList[| 7].enabled = false;
			controlsList[| 8].enabled = true;
		}
		if(_upgraded)
		{
			for(var i=5;i<=8;i++) { _btn = controlsList[| i]; _btn.enabled = false; }
		}
	}
}

function UpgradeTower(_ind){
	if(is_undefined(_ind)) 
	{
		show_debug_message("ERROR at upgradetower: _ind is undefined");
		exit;
	}
	_ind = clamp(_ind,0,15);
	var _obj = -1;
	var _stats = -1;
	var _plus = _ind >= 8;
	var arrTowers = [oTowerMinigun,oTowerBomber,oTowerSniper,oTowerLaser,oTowerBrittle,oTowerFrost,oTowerSpotter,oTowerStalker];
	if(_ind < 8)
	{
		// first upgrade is being purchased
		_obj = arrTowers[_ind];
		_stats = global.iGame.defaultStats[? _obj];
	} else {
		// second upgrade is being purchased
		_obj = arrTowers[_ind-8];
		_stats = global.iGame.defaultStats[? _obj];
		_stats.damage += 1;
		_stats.armorpierce += 1;
		_stats.cooldown -= 0.1;
		_stats.range += 1;
		// buffs specific to the tower type
		switch(_obj)
		{
			case oTowerMinigun: // minigun 
				//
				break;
			case oTowerBomber: // bomber 
				// 
				break;
			case oTowerSniper: // sniper 
				//
				break;
			case oTowerLaser: // laser 
				//
				break;
			case oTowerBrittle: // brittle 
				// 
				break;
			case oTowerFrost: // frostbite 
				//
				break;
			case oTowerSpotter: // spotter 
				//
				break;
			case oTowerStalker: // stalker 
				//
				break;
		}
	}
	if(global.iGame.playerMoney >= _stats.cost)
	{
		global.iGame.playerMoney -= _stats.cost;
		with(global.iUI.targetHover){
			with(instance_create_layer(x,y,"Instances",_obj,_stats))
			{
				// update name to indicate the '+' upgrade
				if(_plus) 
				{
					name += "+";
					switch(sprite_index)
					{
						case sTowerBomber1: sprite_index = sTowerBomber2; break;
						case sTowerSniper1: sprite_index = sTowerSniper2; break;
						case sTowerMinigun1: sprite_index = sTowerMinigun2; break;
						case sTowerLaser1: sprite_index = sTowerLaser2; break;
						case sTowerFrost1: sprite_index = sTowerFrost2; break;
						case sTowerBrittle1: sprite_index = sTowerBrittle2; break;
						case sTowerSpotter1: sprite_index = sTowerSpotter2; break;
						case sTowerStalker1: sprite_index = sTowerStalker2; break;
					}
				}
				global.iUI.targetHover = id;
				global.iUI.targetHoverCheck = id;
				global.iUI.targetClick = true;
			}
			// remove the old tower
			instance_destroy();
		}
		with(global.iUI) UpdateUpgradeButtons();
		show_debug_message("Tower Upgrade Bought, still need to update the specific buffs");
	} else {
		show_debug_message("can't afford upgrade");
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

// upgrade buttons
_x = rectUpgrade[0]; _y = rectUpgrade[1];
_control = ButtonAdd(_x,_y,id,ds_list_size(controlsList),"upgrade1",sBtnUpgrade,,"---",,UpgradeTower,-1);
_x = 1.2*rectUpgrade[0]; _y = rectUpgrade[1];
_control = ButtonAdd(_x,_y,id,ds_list_size(controlsList),"upgrade2",sBtnUpgrade,,"---",,UpgradeTower,-1);
_x = rectUpgrade[0]; _y = 1.2*rectUpgrade[1];
_control = ButtonAdd(_x,_y,id,ds_list_size(controlsList),"upgrade3",sBtnUpgrade,,"---",,UpgradeTower,-1);
_x = 1.2*rectUpgrade[0]; _y = 1.2*rectUpgrade[1];
_control = ButtonAdd(_x,_y,id,ds_list_size(controlsList),"upgrade4",sBtnUpgrade,,"---",,UpgradeTower,-1);
