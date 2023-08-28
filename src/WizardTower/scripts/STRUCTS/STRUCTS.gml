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
    fov_map = ds_grid_create(global.game_grid_width, global.game_grid_height);
    fov_edges = ds_list_create();
    build_map = ds_grid_create(global.game_grid_width, global.game_grid_height);
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
	x = global.game_grid_xorigin + (_xx*GRID_SIZE + (GRID_SIZE div 2));
	y = global.game_grid_yorigin + (_yy*GRID_SIZE + (GRID_SIZE div 2));

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

	static Initialize = function(_grid=undefined){
        if(!is_undefined(_grid)) && (ds_exists(_grid,ds_type_grid))
        {
            maxHeapSize = ds_grid_width(_grid)*ds_grid_height(_grid);
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
	switch(_type)
	{
		case "buy_turret":
			name = _type;
			icon = sImp;
			script = BuilderCreateTurret;
			args = [PLAYER_FACTION];
			title = "Basic Turret";
			description = "Build this to avoid losing\nline 2\n line 3\nline 4\n line 5";
			values = {};
			break;
		case "buy_barricade":
			name = _type;
			icon = sImp;
			script = BuilderCreateBarricade;
			args = [PLAYER_FACTION];
			title = "Basic Barricade";
			description = "Build this to avoid losing\nline 2\n line 3\nline 4\n line 5";
			values = {};
			break;
		case "buy_sentry":
			name = _type;
			icon = sImp;
			script = BuilderCreateSentry;
			args = [PLAYER_FACTION];
			title = "Basic Sentry";
			description = "Build this to avoid losing\nline 2\n line 3\nline 4\n line 5";
			values = {};
			break;
		default:
			name = _type;
			icon = sFollower2;
			script = -1;
			args = -1;
			title = "Test Title";
			description = "Test Description\nline 2\n line 3\nline 4\n line 5";
			values = {};
			break;
	}
}
