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
#macro PATHNODE 1
#macro INDESTRUCTABLE 2
#macro BUILDNODE 3
#macro NOBUILDNODE 4

HexNode = function(grid_obj, q, r) constructor{
	position = hex_to_pixel(q, r);
	coord = vect2(q,r);
	adjacent_nodes = [
		hex_get(vect_add(vect2(q, r), axial_direction_vectors[0])),
		hex_get(vect_add(vect2(q, r), axial_direction_vectors[1])),
		hex_get(vect_add(vect2(q, r), axial_direction_vectors[2])),
		hex_get(vect_add(vect2(q, r), axial_direction_vectors[3])),
		hex_get(vect_add(vect2(q, r), axial_direction_vectors[4])),
		hex_get(vect_add(vect2(q, r), axial_direction_vectors[5]))];
}

function InitHexagonalGrid(_tile_type, _offset_type, _size, _ox, _oy){
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
		
	}
	global.i_hex_grid = instance_create_layer(0,0,"Instances",o_hex_grid,_struct);
}

