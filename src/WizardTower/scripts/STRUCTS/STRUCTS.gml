// Actor is the object class that will control units/structures of other factions
Actor = function(_player=false, _faction, _apm=0, _ai=undefined) constructor{
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
    material_per_second = 40;
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

    static CalcFovEdges = function(){
        var i, j, k, _x, _y, edge;
        var node, e_node, n_node, w_node, s_node;
        // this creates the data needed to efficiently calculate field of view tiles, to be set using another function, based on unit line of sight
        ds_list_clear(fov_edges);
        for(i=0;i<global.game_grid_width;i++){
        for(j=0;j<global.game_grid_height;j++){
            var _node = global.game_grid[# i, j];
            for(k=0;k<4;k++)
            {
                _node.edge_id[k] = 0;
                _node.edge_exists[k] = false;
            }
        }}
		
		// Iterate through region from top left to bottom right
		for (i=1; i< global.game_grid_width-1; i++){
		for (j=1; j< global.game_grid_height-1; j++){
			// Create some convenient indices
            node = global.game_grid[# i, j];       // This
            n_node = global.game_grid[# i, j-1];   // Northern Neighbour
            s_node = global.game_grid[# i, j+1];   // Southern Neighbour
            w_node = global.game_grid[# i-1, j];   // Western Neighbour
            e_node = global.game_grid[# i+1, j];   // Eastern Neighbour

			// If this cell exists, check if it needs edges
			if(node.block_sight)
			{
				// If this cell has no western neighbour, it needs a western edge
				if(!w_node.block_sight)
				{
					// It can either extend it from its northern neighbour if they have
					// one, or It can start a new one.
					if (n_node.edge_exists[WEST])
					{
						// Northern neighbour has a western edge, so grow it downwards
                        fov_edges[| n_node.edge_id[WEST]].y2 += GRID_SIZE;
						node.edge_id[WEST] = n_node.edge_id[WEST];
						node.edge_exists[WEST] = true;
					} else {
						// Northern neighbour does not have one, so create one
						_x = node.xx*GRID_SIZE
						_y = node.yy*GRID_SIZE
						edge = new global.iEngine.Edge(_x,_y,_x,_y+GRID_SIZE);
						// Add edge to Polygon Pool
						ds_list_add(fov_edges, edge)

						// Update tile information with edge information
						node.edge_id[WEST] = ds_list_size(fov_edges)-1;
						node.edge_exists[WEST] = true;
					}
				}

				// If this cell dont have an eastern neignbour, It needs a eastern edge
				if (!e_node.block_sight) 					{
					// It can either extend it from its northern neighbour if they have
					// one, or It can start a new one.
					if (n_node.edge_exists[EAST])
					{
						// Northern neighbour has one, so grow it downwards
                        fov_edges[| n_node.edge_id[EAST]].y2 += GRID_SIZE;
						node.edge_id[EAST] = n_node.edge_id[EAST];
						node.edge_exists[EAST] = true;
					} else {
						// Northern neighbour does not have one, so create one
						_x = node.xx*GRID_SIZE
						_y = node.yy*GRID_SIZE
						edge = new global.iEngine.Edge(_x+GRID_SIZE,_y,_x+GRID_SIZE,_y+GRID_SIZE);
						// Add edge to Polygon Pool
						ds_list_add(fov_edges, edge)

						// Update tile information with edge information
						node.edge_id[EAST] = ds_list_size(fov_edges)-1;
						node.edge_exists[EAST] = true;
					}
				}

				// If this cell doesnt have a northern neignbour, It needs a northern edge
				if (!n_node.block_sight)
				{
					// It can either extend it from its western neighbour if they have
					// one, or It can start a new one.
					if (w_node.edge_exists[NORTH])
					{
						// Western neighbour has one, so grow it eastwards
                        fov_edges[| w_node.edge_id[NORTH]].x2 += GRID_SIZE;
						node.edge_id[NORTH] = w_node.edge_id[NORTH];
						node.edge_exists[NORTH] = true;
					} else {
						// Western neighbour does not have one, so create one
						_x = node.xx*GRID_SIZE
						_y = node.yy*GRID_SIZE
						edge = new global.iEngine.Edge(_x,_y,_x+GRID_SIZE,_y);
						// Add edge to Polygon Pool
						ds_list_add(fov_edges, edge);

						// Update tile information with edge information
						node.edge_id[NORTH] = ds_list_size(fov_edges)-1;
						node.edge_exists[NORTH] = true;
					}
				}

				// If this cell doesnt have a southern neignbour, It needs a southern edge
				if(!s_node.block_sight)
				{
					// It can either extend it from its western neighbour if they have
					// one, or It can start a new one.
					if (w_node.edge_exists[SOUTH])
					{
						// Western neighbour has one, so grow it eastwards
                        fov_edges[| w_node.edge_id[SOUTH]].x2 += GRID_SIZE;
						node.edge_id[SOUTH] = w_node.edge_id[SOUTH];
						node.edge_exists[SOUTH] = true;
					} else {
						// Western neighbour does not have one, so I need to create one
						_x = node.xx*GRID_SIZE
						_y = node.yy*GRID_SIZE
						edge = new global.iEngine.Edge(_x,_y+GRID_SIZE,_x+GRID_SIZE,_y+GRID_SIZE);
						// Add edge to Polygon Pool
						ds_list_add(fov_edges, edge)

						// Update tile information with edge information
						node.edge_id[SOUTH] = ds_list_size(fov_edges)-1;
						node.edge_exists[SOUTH] = true;
					}
				}
			}
        }}
		// add the boundaries of the room as edges
		ds_list_add(fov_edges, global.iEngine.boundary_edges[EAST]);
		ds_list_add(fov_edges, global.iEngine.boundary_edges[NORTH]);
		ds_list_add(fov_edges, global.iEngine.boundary_edges[WEST]);
		ds_list_add(fov_edges, global.iEngine.boundary_edges[SOUTH]);
    }

	static CalcVisionPolygon = function(_poly_list, _entity, _edges){
		// polygon is a list, each item in the list is a vertex represented as a struct containing: {angle with regard to the entity, [x] of referenced edge vertex, [y] of said edge vertex} 
		ds_list_clear(_poly_list);
		var _range = _entity.los_radius*GRID_SIZE;
		var _offset_range = global.game_grid_width*GRID_SIZE; // the offset rays must be sufficiently long to collide with the bounderies of the room
		var _ray_list = ds_list_create();
		var _edge_count = ds_list_size(_edges);
		var edge = undefined, ray = undefined, rdx=0, rdy=0, edx=0, edy=0, t1=0, t2=0, _ind = 0, _ang = 0;
		var min_t1 = infinity, min_px=0, min_py=0, min_ang=0, _valid=false;
		var _ang_deviation = 0.01; // degrees

		// fill list with valid rays
		for(var i=0;i<_edge_count;i++)
		{
			edge = _edges[| i];
			// check first point of the edge
			if(point_distance(_entity.position[1], _entity.position[2], edge.x1, edge.y1) <= _range)
			{
				_ang = point_direction(_entity.position[1], _entity.position[2], edge.x1, edge.y1);
				// MAIN
				ray = {angle : _ang, x : edge.x1, y : edge.y1, is_offset : false};
				_valid = true;
				// prevent duplicates from being added to the ray list
				for(var k=0;k<ds_list_size(_ray_list);k++){	if(ray.angle == _ray_list[| k].angle) _valid = false; }
				if(_valid)
				{
					// add main ray, then add the offset rays
					ds_list_add( _ray_list, ray);
					// NEGATIVE OFFSET
					_ang = _ang - _ang_deviation;
					ds_list_add( _ray_list, {angle : _ang, x : _entity.position[1] + lengthdir_x(_offset_range, _ang), y : _entity.position[2] + lengthdir_y(_offset_range, _ang), is_offset : true} );
					// POSITIVE OFFSET
					_ang = _ang + 2*_ang_deviation;
					ds_list_add( _ray_list, {angle : _ang, x : _entity.position[1] + lengthdir_x(_offset_range, _ang), y : _entity.position[2] + lengthdir_y(_offset_range, _ang), is_offset : true} );
				}
			}
			// check second point of the edge
			if(point_distance(_entity.position[1], _entity.position[2], edge.x2, edge.y2) <= _range)
			{
				_ang = point_direction(_entity.position[1], _entity.position[2], edge.x2, edge.y2);
				// MAIN
				ray = {angle : _ang, x : edge.x2, y : edge.y2, is_offset : false};
				_valid = true;
				// prevent duplicates from being added to the ray list
				for(var k=0;k<ds_list_size(_ray_list);k++){	if(ray.angle == _ray_list[| k].angle) _valid = false; }
				if(_valid)
				{		
					// MAIN
					ds_list_add( _ray_list, ray);
					// NEGATIVE ANGLE
					_ang -= _ang_deviation;
					ds_list_add( _ray_list, {angle : _ang, x : _entity.position[1] + lengthdir_x(_offset_range, _ang), y : _entity.position[2] + lengthdir_y(_offset_range, _ang), is_offset : true} );
					// POSITIVE ANGLE
					_ang += 2*_ang_deviation;
					ds_list_add( _ray_list, {angle : _ang, x : _entity.position[1] + lengthdir_x(_offset_range, _ang), y : _entity.position[2] + lengthdir_y(_offset_range, _ang), is_offset : true} );
				}
			}
		}
		
		// run raycast collisions
		for(var i=ds_list_size(_ray_list)-1; i>=0; i--)
		{
			ray = _ray_list[| i];
			rdx = ray.x - _entity.position[1];
			rdy = ray.y - _entity.position[2];
			min_t1 = infinity;
			// min_px=0; min_py=0; min_ang=0;
			min_px = ray.x; min_py = ray.y; min_ang = ray.angle;
			_valid = false;
			for(var j=0; j<_edge_count; j++)
			{
				edge = _edges[| j];
			    edy = edge.y2 - edge.y1;
			    edx = edge.x2 - edge.x1;

				// calculate intersections between ray and edges
				if(abs(edx-rdx) > 0) && (abs(edy-rdy) > 0)
				{
					// t2 is normalised distance from line segment start to line segment end of intersect point
					// float t2 = (rdx * (e2.sy - oy) + (rdy * (ox - e2.sx))) / (sdx * rdy - sdy * rdx);
					var t2 = (rdx*(edge.y1 - _entity.position[2]) + (rdy * (_entity.position[1] - edge.x1))) / (edx*rdy - edy*rdx);
	
					// t1 is normalised distance from source along ray to ray length of intersect point
					//float t1 = (e2.sx + sdx * t2 - ox) / rdx;	
					var t1 = (edge.x1 + edx * t2 - _entity.position[1]) / rdx;
		
					// If intersect point exists along ray, and along line 
					// segment then intersect point is valid
					if(t1 > 0) && (t2 >= 0) && (t2 <= 1) 
					{
							// show_debug_message("intersection exists: min_t1={0} | t1={1} | t2={2} | compare test[ t1 < min_t1 ]={3}", min_t1, t1, t2, t1<min_t1);
							// Check if this intersect point is closest to source. If
							// it is, then store this point and reject others
							if (t1 < min_t1)
							{
								min_t1 = t1;
								min_px = _entity.position[1] + rdx*t1;
								min_py = _entity.position[2] + rdy*t1;
								min_ang = ray.angle;  // atan2f(min_py - oy, min_px - ox);
								_valid = true;
							}
					}
				}
			}

			// add the intersection point to the polygon, also add rays which did not collide with any
			if(_valid)
			{
				// sort polygon points by ascending angle values, as they are inserted into the list of points
				_ind = 0;
				while(_ind < ds_list_size(_poly_list))
				{
					if(_poly_list[| _ind].angle <= min_ang) { _ind++ } else { break }
				}
				// add to polygon
				ds_list_insert( _poly_list, _ind, { angle : min_ang, x : min_px, y : min_py } );
			}
		}
		ds_list_destroy(_ray_list);
	}

    static CalcFovMap = function(){
        // does a raycast to LoS perimeter

        //notes on process:
        /*
            convert blocks in tilemap into a polygon map for the LoS algorithm to use
        */
		var _vis_polygon = undefined;
		var _los_rad = 0, _xx = 0, _yy = 0;
		var _ent = noone, _ang = 0, _dist = 0, _node = undefined, _size = 0, edge = undefined, valid = false;
		var _w=0, _h=0, _cw=0, _ch=0;
		
		// clear the fov map
		for(var i=0; i<global.game_grid_width; i++){
		for(var j=0; j<global.game_grid_height; j++){
			if(fov_map[# i, j] == VISION.SIGHTED) fov_map[# i, j] = VISION.SEEN;
		}}

		// calculate line of sight for structures
		if(structure_count > 0)
		{
            for(var num=0; num<structure_count; num++)
            {
				_ent = structures[| num];
				_xx = _ent.xx;
				_yy = _ent.yy;
				_los_rad = _ent.los_radius;
				
				_w = _ent.size[0];
				_h = _ent.size[1];
				_cw = _w div 2;
				_ch = _h div 2;
				// give vision to every tile inside LoS radius
				for(var i=-_los_rad-_cw; i<_w-_cw+_los_rad; i++){
				for(var j=-_los_rad-_ch; j<_h-_ch+_los_rad; j++){
					if(point_in_rectangle(_xx+i, _yy+j, 0, 0, global.game_grid_width, global.game_grid_height))
					{
						_node = global.game_grid[# _xx+i, _yy+j];
						if(point_distance(_ent.position[1], _ent.position[2], _node.x, _node.y) <= _los_rad*1.2*GRID_SIZE) fov_map[# _xx+i, _yy+j] = VISION.SIGHTED;
					}
				}}				
			}
		}

		// calculate line of sight for units
        if(unit_count > 0)
        {
            for(var num=0; num<unit_count; num++)
            {
				_ent = units[| num];
				_vis_polygon = _ent.los_polygon;
				_xx = _ent.xx;
				_yy = _ent.yy;
				_los_rad = _ent.los_radius;
				// get visibility polygon
				CalcVisionPolygon(_vis_polygon, _ent, fov_edges);
				_size = ds_list_size(_vis_polygon);
				//show_debug_message("vis polygon calculated, size is : {0}", _size);
				// for each node in LoS range, check if it is in the vision polygon ( raycast collisions with polygon )
				for(var i=-_los_rad; i<=_los_rad; i++){
				for(var j=-_los_rad; j<=_los_rad; j++){
					// filter invalid nodes
					if(point_distance(_xx,_yy, _xx+i, _yy+j) <= _los_rad+0.5) && (point_in_rectangle(_xx+i, _yy+j, 0, 0, global.game_grid_width-1, global.game_grid_height-1)) 
					{
						// see if the node is already seen
						if(fov_map[# _xx+i, _yy+j] == VISION.SIGHTED) continue;
						
						// get node and check for vision
						_node = global.game_grid[# _xx+i, _yy+j];
						valid = false;

						// raycast to the node, if no collision occurs then the node is sighted
						for(var k=0;k<ds_list_size(fov_edges);k++)
						{
							edge = fov_edges[| k];
							
							// ignore if the edge points are too far away
							if(point_distance(_ent.position[1], _ent.position[2], edge.x1, edge.y1) > _los_rad*GRID_SIZE)
							&& (point_distance(_ent.position[1], _ent.position[2], edge.x2, edge.y2) > _los_rad*GRID_SIZE){
								// skip to next edge
								continue;
							}

							// check for intersections  -|-|-  vect_does_intersect(x1, y1, dx1, dy1, x2, y2, dx2, dy2)
							if(vect_does_intersect(_ent.position[1], _ent.position[2], _node.x-_ent.position[1], _node.y-_ent.position[2], 
							                       edge.x1, edge.y1, edge.x2-edge.x1, edge.y2-edge.y1)){
								valid = true;
								break;
							}
						}
						// skip node if intersection detected
						if(valid) continue;

						// set the node as sighted
						fov_map[# _xx+i, _yy+j] = VISION.SIGHTED;
					}
				}}
			}
        }
    }
	static SetFogOfWar = function(){
		if(!layer_tilemap_exists(global.iEngine.fog_of_war_layer, global.fog_of_war)) exit;
		for(var i=0; i<global.game_grid_width; i++){
		for(var j=0; j<global.game_grid_height; j++){
			if( tilemap_get(global.fog_of_war, i, j) != fov_map[# i, j]) tilemap_set(global.fog_of_war, fov_map[# i, j], i, j); 
		}}
	}
}

//  spearbearer, physical dps (throw spear dealing damage, unit can't attack while on cooldown but can retrieve the spear to reset the cooldown)
//  shieldbearer, physical support (greatly raise defense and mass, but cannot move or attack)
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
