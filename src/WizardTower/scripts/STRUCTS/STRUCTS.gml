// Actor is the object class that will control units/structures of other factions
Actor = function(_player=false, _faction=NEUTRAL_FACTION, _apm=0, _ai=undefined) constructor{
    // parameters
    player = _player;
    faction = _faction;
	actions_per_minute = _apm;
	action_timer = FRAME_RATE*3;
	action_pause = false;
    supply_limit = 40;
    supply_current = 0;
    supply_in_queue = 0;
	money_rate = 1;
    material = 0;
    material_per_second = 0;
	experience_points = 0;
	upgrade_points = 0;
    fov_update_time = 20;
    fov_update_timer = -1;
    
	// components
    ai = _ai; 

    // data structures
	fighter_stats = new global.iEngine.FighterStats();
    selected_entities = ds_list_create();
    blueprints = ds_list_create();
    blueprint_count = 0;
    units = ds_list_create();
	unit_count = 0;
    structures = ds_list_create();
	structure_count = 0;
    control_groups = ds_list_create();
}

//  spearbearer, physical dps (throw spear dealing damage, unit can't attack while on cooldown but can retrieve the spear to reset the cooldown)
//  summoner, physical support (greatly raise defense and mass, but cannot move or attack)
//  lensbearer, magical dps (lock onto a target, dealing ramping damage for duration of the attack)
//  torchbearer, magical support (illuminate to increase vision radius and damage nearby enemies, reduces movement speed)


Edge = function(_x1, _y1, _x2, _y2) constructor{
	x1 = _x1;
	y1 = _y1;
	x2 = _x2;
	y2 = _y2;
}

Node = function(_xx, _yy) constructor{
	// scalar values (and average velocity)
	xx = _xx;
	yy = _yy;
	x = global.game_grid_bbox[0] + (_xx*GRID_SIZE + (GRID_SIZE div 2));
	y = global.game_grid_bbox[1] + (_yy*GRID_SIZE + (GRID_SIZE div 2));

    // heap variables
    HeapIndex = 0;
	parent = undefined;
	occupied_list = ds_list_create();
    occupied_blueprint = noone;
    blocked = false;
    block_sight = false;
    walkable = true;
    discomfort = 0;

    // field of view variables
    edge_id = array_create(4, -1);
    edge_exists = array_create(4, false);
	
    static CompareTo = function(_otherNode) 
    {
		var _compare = 0;
		if(path_cost == undefined) || (_otherNode.path_cost == undefined)
		{
			// compare based only on goal cost
			_compare = goal_cost <= _otherNode.goal_cost ? 1 : -1;
			return _compare;
		} 
		
		// normal comparison
		if(path_cost != _otherNode.path_cost){ 
			// pick priority
			_compare = path_cost < _otherNode.path_cost ? 1 : -1;
		}else{
			// tie breaker
			_compare = goal_cost <= _otherNode.goal_cost ? 1 : -1;
		}
		return _compare;
    }
}

NodeHeap = function() constructor
{
	currentItemCount = 0;
	maxHeapSize = global.game_grid_width*global.game_grid_height;
	items = array_create(maxHeapSize, -1);

	static Initialize = function(index_array=undefined){
        if(!is_undefined(index_array)) && (is_array(index_array))
        {
            maxHeapSize = array_length(index_array);
        }
        items = array_create(maxHeapSize, undefined);
		currentItemCount = 0;
	}
	static Add = function(_item){
		_item.HeapIndex = currentItemCount;
		items[currentItemCount] = _item;
		SortUp(_item);
		currentItemCount++;
	}
	static RemoveFirst = function(){
		var _firstItem = items[0];
		currentItemCount--;
		items[0] = items[currentItemCount];
		items[0].HeapIndex = 0;
		SortDown(items[0]);
		return _firstItem;
	}
	static UpdateItem = function(_item){
		SortUp(_item);
	}
	static Count = function(){
		return currentItemCount;
	}
	static Contains = function(_item){
		var _checkItem = items[_item.HeapIndex];
		return _checkItem == undefined ? false : (_checkItem.xx == _item.xx) and (_checkItem.yy == _item.yy);
		
		//return array_equals(items[_item.HeapIndex].cell, _item.cell);
	}
	static SortUp = function(_item){
		var _parentIndex = (_item.HeapIndex-1)/2;
		while(true)
		{
			var _parentItem = items[_parentIndex];
			if(_item.CompareTo(_parentItem) > 0)
			{
				Swap(_item,_parentItem);
			} else {
				break;
			}
			_parentIndex = (_item.HeapIndex-1)/2;
			return _parentIndex;
		}
	}
	static SortDown = function(_item){
		while(true)
		{
			var _childIndexLeft = _item.HeapIndex*2 + 1; 
			var _childIndexRight = _item.HeapIndex*2 + 2;
			var _swapIndex = 0;
			
			if(_childIndexLeft < currentItemCount)
			{
				_swapIndex = _childIndexLeft;
				
				if(_childIndexRight < currentItemCount)
				{
					if(items[_childIndexLeft].CompareTo(items[_childIndexRight]) < 0)
					{
						_swapIndex = _childIndexRight;
					}
				}
				if(_item.CompareTo(items[_swapIndex]) < 0)
				{
					Swap(_item, items[_swapIndex]);
				} else {
					return;
				}
			} else {
				return;
			}
		}
	}
	static Swap = function(itemA,itemB){
		items[itemA.HeapIndex] = itemB;
		items[itemB.HeapIndex] = itemA;
		var _itemAIndex = itemA.HeapIndex;
		itemA.HeapIndex = itemB.HeapIndex;
		itemB.HeapIndex = _itemAIndex;
	}
}

Command = function(_type="", _value=undefined, _x=0, _y=0) constructor{
    type = _type;
    value = _value;
    x = _x; 
    y = _y;
}

Ability = function(_type="") constructor{
	
	var _structure_list = ds_list_create();
	ds_list_add(_structure_list,"barricade","gunturret","sniperturret","barracks","dronesilo","flameturret","mortarturret");
	name = _type;
	show_debug_message("type is {0}",_type);
	if(ds_list_find_index(_structure_list,_type) > -1)
	{
		var _stats = global.iEngine.player_actor.fighter_stats[$ _type];
		show_debug_message("stats is {0}", _stats);
		values = {
			cost : _stats.material_cost
		}
	}
	switch(_type)
	{
		// defense
		case "barricade":	
		    name = "Barricade";
		    icon = sIconBarricade;
			script = BuilderCreateBarricade;
			args = [PLAYER_FACTION];
			title = "Barricade";
			description = "Will block the way for incoming enemies.  can be upgraded for varying effects";
		    values = {};
		    break;
		case "barricade-spike wall":	
		    name = "Specialzation - Spike Wall";
		    icon = sIconBarricadeSpike;
		    script = -1;
		    args = [];
		    title = -1;
		    description = -1;
		    values = {}; 
		    break;
		case "barricade-heal beacon":	
		    name = "Specialzation - Heal Beacon";
		    icon = sIconBarricadeHeal;
		    script = -1;
		    args = [];
		    title = -1;
		    description = -1;
		    values = {}; 
		    break;
		case "barricade-mine dispenser":	
		    name = "Specialzation - Mine Layer";
		    icon = sIconBarricadeMine;
		    script = -1;
		    args = [];
		    title = -1;
		    description = -1;
		    values = {}; 
		    break;

		// kinetic
		case "kinetic tower":	
		    name = "Kinetic Tower";
		    icon = sIconKinetic;
		    script = BuilderCreateGunTurret;
		    args = [PLAYER_FACTION];
		    title = "Gun Turret";
		    description = "The most basic for source of kinetic-type damage.";
		    values = {}; 
		    break;
		case "kinetic-minigun":	
		    name = "Specialzation - Minigun";
		    icon = sIconKineticMinigun;
		    script = SpecializationCreateMinigun;
		    args = [];
		    title = "Specialzation - Minigun";
		    description = "Verstile, basic turret with moderate range.\nline 2\n line 3\nline 4\n line 5";
		    values = {};
		    break;
		case "kinetic-sniper":
		    name = "Specialzation - Sniper";
		    icon = sIconKineticSniper;
		    script = SpecializationCreateSniper;
		    args = [];
		    title = "Specialzation - Sniper";
		    description = "Build this to avoid losing\nline 2\n line 3\nline 4\n line 5";
		    values = {};
		    break;
		case "kinetic-mortar":	
		    name = "Specialzation - Mortar";
		    icon = sIconKineticMortar;
		    script = SpecializationCreateMortar;
		    args = [];
		    title = "Basic Mortar Turret";
		    description = "Long range turret with area damage, but fires slowly\nline 2\n line 3\nline 4\n line 5";  
		    values = {};
		    break;

		//magic
		case "magic tower":	
		    name = "Magic Tower";
		    icon = sIconMagic;
		    script = BuilderCreateMagicTurret;
		    args = [PLAYER_FACTION];
		    title = "Basic Magic Tower";
		    description = "Produces drones that fly into nearby enemies\nline 2\n line 3\nline 4\n line 5";
		    values = {}; 
		    break;
		case "magic-fire emitter":
		    name = "Specialization - Fire Emitter";
		    icon = sIconMagicFire;
		    script = BuilderCreateFlameTurret;
		    args = [PLAYER_FACTION];
		    title = "Specialization - Fire Emitter";
		    description = "Deals constant damage to nearby enemies."; 
		    values = {}; 
		    break;
		case "magic-ice impaler":
		    name = "Specialization - Ice Spear";
		    icon = sIconMagicIce;
		    script = BuilderCreateBarracks;
		    args = [PLAYER_FACTION];
		    title = "Specialization - Ice Spear";
		    description = "This will produce a barracks instead of an ice tower";
		    values = {}; 
		    break;
		case "magic-lightning striker":
		    name = "Specialzation - Lighting Strike";
		    icon = sIconMagicLightning;
		    script = BuilderCreateBarracks;
		    args = [PLAYER_FACTION];
		    title = "Specialization - Lightning Strike";
		    description = "This will produce a barracks instead of an lightning tower";
		    values = {}; 
		    break;

//--// OTHER STUFF (these are old/unused)
		case "gunturret":
		    icon = sGunTurretIcon;
		    script = BuilderCreateGunTurret;
		    args = [PLAYER_FACTION];
		    title = "Basic Gun Turret";
		    description = "Verstile, basic turret with moderate range.\nline 2\n line 3\nline 4\n line 5";
		break;
		case "sniperturret":
		    icon = sSniperIcon;
		    script = BuilderCreateSniper;
		    args = [PLAYER_FACTION];
		    title = "Basic Sniper Turret";
		    description = "Build this to avoid losing\nline 2\n line 3\nline 4\n line 5";
		break;
		case "barracks":
		    icon = sBarracksIcon;
		    script = BuilderCreateBarracks;
		    args = [PLAYER_FACTION];
		    title = "Basic Infantry Barracks";
		    description = "Produces units that move as a squad\nline 2\n line 3\nline 4\n line 5";   
		break;
		case "dronesilo":
		    icon = sBombDroneIcon;
		    script = BuilderCreateBombDrone;
		    args = [PLAYER_FACTION];
		    title = "Basic Drone Silo";
		    description = "Produces drones that fly into nearby enemies\nline 2\n line 3\nline 4\n line 5";     
		break;
		case "flameturret":
		    icon = sFlameTurretIcon;
		    script = BuilderCreateFlameTurret;
		    args = [PLAYER_FACTION];
		    title = "Basic Flame Turret";
		    description = "Deals constant damage to nearby enemies\nline 2\n line 3\nline 4\n line 5";   
		break;
		case "mortarturret":
		    icon = sMortarIcon;
		    script = BuilderCreateMortarTurret;
		    args = [PLAYER_FACTION];
		    title = "Basic Mortar Turret";
		    description = "Long range turret with area damage, but fires slowly\nline 2\n line 3\nline 4\n line 5";     
		break;
		
//------// Upgrade Abilities
		case "level up":// this is an upgrade for towers on an individual basis
			name = "LEVEL UP";
		    icon = sIconLevelUp;
		    script = -1;
		    args = [];
		    title = -1;
		    description = -1;
		    values = {}; 
			break;
		case "health_up":
		    icon = sIconUpgradeHealth;
		    script = player_upgrade_health_up;
		    args = [2];
		    title = "Health +";
		    description = "Slightly increase your overall health.";
		    values = {};  
		break;
		case "money_up":
		    icon = sIconUpgradeMoney;
		    script = player_upgrade_money_up;
		    args = [0.1];
		    title = "Money Gain +";
		    description = "You will earn a greater reward for defeating enemies";
		    values = {};  
		break;
		case "supply_up":
		    icon = sIconUpgradeSupply;
		    script = player_upgrade_supply_up;
		    args = [2];
		    title = "Supply +";
		    description = "You can support additional towers/units on the field";
		    values = {};  
		break;
		
//------// Miscelaneous Abilities
		case "toggle_info":
		    icon = sIconInfo;
		    script = ToggleEntityInfo;
		    args = [PLAYER_FACTION];
		    title = "Toggle Info";
		    description = "Show information for anything on screen.  Including health, attack range, enemy levels, etc... \nline 2\n line 3\nline 4\n line 5";
		    values = {};  
		break;
		case "sell_this_tower":
			name = "Sell This";
		    icon = sIconSellOne;
		    script = -1;
		    args = [];
		    title = -1;
		    description = -1;
		    values = {}; 
			break;
		case "sell_towers":
		    icon = sIconSellMany;
		    script = ToggleSellMode;
		    args = [PLAYER_FACTION];
		    title = "Sell Structures";
		    description = "Enter \'Sell Mode\'.  Click on towers to sell them.  \nline 2\n line 3\nline 4\n line 5";
		    values = {}; 
		break;
		default:
			name = "null";
		    icon = -1;
		    script = -1;
		    args = [];
		    title = -1;
		    description = -1;
		    values = {}; 
			break;
	}
	ds_list_destroy(_structure_list);
}
