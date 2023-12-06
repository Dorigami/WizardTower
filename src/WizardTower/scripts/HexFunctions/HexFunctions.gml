/*
	this script is intended to contain everything that is needed to instantiate a 
	hexagonal grid system for use in projects.  it assumes 'Axial' coordinates are used
	and can alternate hexagon types and sizes (this hsould be updated to use variables for 
	the grid properties instead of macros).  The 'vector_functions' will be reference in 
	conjuction with this one to supplement sone of the functions.
	
	All functions must be run by the hex_grid object in order to variable references to work
*/

#macro FLATTOP 0
#macro POINTYTOP 1
#macro ODD_R 0
#macro EVEN_R 1
#macro ODD_Q 2
#macro EVEN_Q 3

// node types
#macro NULLNODE 0
#macro SPAWNNODE 1
#macro GOALNODE 2

function InitHexagonalGrid(_tile_type, _offset_type, _size, _ox, _oy, _max_width, _max_height){
	// _type determines whether it uses pointy-top or flat-top hexagons
	// _offset determines how the tiles' position will be offset (Q refers to column offset & R refere to row offset)
	// _size represents the 'radius' of a circle which contains the hexagon
	var _struct = {
		hex_type : _tile_type,
		hex_size : _size,
		offset_type : _offset_type,
		origin :  vect2(_ox, _oy),
		h_spacing : _tile_type ? sqrt(3)*_size : 1.5*_size,
		v_spacing : _tile_type ? 1.5*_size : sqrt(3)*_size,
		axial_direction_vectors : [
			vect2(1,0),vect2(1,-1),vect2(0,-1),
			vect2(-1,0),vect2(-1,1),vect2(0,1)
		],
		hexgrid_width_max : _max_width,
		hexgrid_height_max : _max_height,
		hexgrid_height_pixels : 0,
		hexgrid_width_pixels : 0,
	}
	global.i_hex_grid = instance_create_layer(_ox, _oy, "Instances",o_hex_grid, _struct);
	
	// create all data structures
	with(global.i_hex_grid){
		var _cellcount = hexgrid_width_max*hexgrid_height_max;
		
		hexmap_loaded_filename = "";
		hexmap = ds_map_create(); // stores index values to be used

		// calc the width and height of the grid
		hexgrid_width_pixels = hexgrid_width_max*h_spacing;
		hexgrid_height_pixels = hexgrid_height_max*v_spacing;
		show_debug_message("0. {0}\n1. {1}\n2. {2}\n3. {3}\n4. {4}\n5. {5}",hexgrid_width_pixels,hexgrid_width_max,h_spacing,hexgrid_height_pixels,hexgrid_height_max,v_spacing);
	
		// set data arrays
		hexgrid_enabled_list = ds_list_create();
		hexgrid_spawn_list = ds_list_create();
		hexgrid_goal_list = ds_list_create();
		hexarr_is_spawn = array_create(_cellcount,0);
		hexarr_is_goal = array_create(_cellcount,0);
		hexarr_enabled = array_create(_cellcount,1);
		hexarr_positions = array_create(_cellcount,1);
		hexarr_hexes = array_create(_cellcount,1);
		
		// create the hex nodes / determine the index values for each node
		var ind = 0;
		var qmin = (hexgrid_width_max div 2);
		var rmin = (hexgrid_height_max div 2);
		for(var i=0; i<hexgrid_height_max; i++){
		for(var j=0; j<hexgrid_width_max; j++){
			var r = i;
			var q = j - floor(r/2);
			// set grid origin to the top left corner
			if(i==0) && (j==0)
			{
				r -= rmin;
				q -= qmin;
				var _pos = hex_to_pixel([2,q,r], true);
				x = _pos[1];
				y = _pos[2];
				r+=rmin;
				q+=qmin;
			}
			// initialize the node index
			ds_map_add(hexmap, hex_get_key([2,q,r]), ind);
			hexarr_enabled[ind] = false;
			hexarr_positions[ind] = hex_to_pixel([2,q,r], true);
			hexarr_hexes[ind] = vect2(q,r);
			ind++;
		}}
		
		with(global.iCamera){
			xTo = _ox;
			yTo = _oy;
			x = _ox;
			y = _oy;
			cam_bounds[0] = other.x - (other.h_spacing div 2);
			cam_bounds[1] = other.y - (other.v_spacing div 2);
			cam_bounds[2] = other.x + other.hexgrid_width_pixels;
			cam_bounds[3] = other.y + other.hexgrid_height_pixels - (other.v_spacing div 2);
		}
	}
}

function hex_find_nearest_goal(hex)
{
	with(global.i_hex_grid)
	{
		var _size = ds_list_size(hexgrid_spawn_list);
		if(_size == 0)
		{
			return undefined;
		} else {
			var _lowest_dist = 0;
			var _lowest_index = hexgrid_spawn_list[| 0];
			var _new_dist = 0;
			for(var i=1;i<_size;i++)
			{
				
				_new_dist = axial_distance();
			}
		}
	}
}

function hex_find_path_for_unit(_entity, _goal_hex_index){

}
