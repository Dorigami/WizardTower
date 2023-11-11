/*
	this script is intended to contain everything that is needed to instantiate an a 
	hexagonal grid system for use in projects.  it assumes 'Axial' coordinates are used
	and can alternate hexagon types and sizes (this hsould be updated to use variables for 
	the grid properties instead of macros).  The 'vector_functions' will be reference in 
	conjuction with this one to supplement sone of the functions.
*/

#macro FLATTOP 0
#macro POINTYTOP 1
#macro ODD_R 0
#macro EVEN_R 1
#macro ODD_Q 2
#macro EVEN_Q 3
#macro HEX_SIZE 30




function InitHexagonalGrid(_tile_type, _offset_type, _size, _ox, _oy){
	// _type determines whether it uses pointy-top or flat-top hexagons
	// _offset determines how the tiles' position will be offset (Q refers to column offset & R refere to row offset)
	// _size represents the 'radius' of a circle which contains the hexagon
	var _struct = {
		type : _tile_type,
		hex_size : _size,
		offset_type : _offset_type,
		origin :  vect2(_ox, _oy),
		h_spacing : _tile_type ? sqrt(3)*_size : 1.5*_size,
		v_spacing : _tile_type ? 1.5*_size : sqrt(3)*_size,
		axial_direction_vectors : [
			vect2(1,0),vect2(1,-1),vect2(0,-1),
			vect2(-1,0),vect2(-1,1),vect2(0,1)
		]
	}
	global.i_hex_grid = instance_create_layer(0,0,"Instances",o_hex_grid,_struct);
}

function calc_hex_corner(center, size, i, type){
	// center is a vector2 of the center of the hexagon

    var angle_deg = 60 * i - (30*type) // will offset angle when pointy-top is used
    var angle_rad = PI / 180 * angle_deg
    return vect2(center[1] + size * cos(angle_rad), center[2] + size * sin(angle_rad))
}


//--// direction & neighbors
function axial_direction(_ind){
	return axial_direction_vectors[_ind];
}

function axial_neighbor(hex_vect, direction){
	return vect_add(hex_vect, axial_direction_vectors[direction]);
}

//--// distances
function axial_distance(v0, v1){
	return (
		abs(v0[1]-v1[1])
		+ abs(v0[1]+v0[2] - v1[1]-v1[2])
		+ abs(v0[2]-v1[2])
	) / 2;
}
function axial_linedraw(p0, p1){
	// return an array of floating point values, representing points along the line.
	// p0 & p1 vector2 for the start and end positions respectively
	var n = axial_distance(p0, p1);
	var arr = array_create(n+1, 0);
	var cube0 = axial_to_cube(p0);
	var cube1 = axial_to_cube(p1);
	for(var i=0;i<=n;i++)
	{
		arr[i] = cube_round(cube_lerp(cube0, cube1, i/N));
	}
	return arr;
}

//--// rounding to nearest hex
function cube_round(vect){
	var q = round(vect[1]);
	var r = round(vect[2]);
	var s = round(vect[3]);
	
	var q_diff = abs(q-vect[1]);
	var r_diff = abs(r-vect[2]);
	var s_diff = abs(s-vect[3]);

    if(q_diff > r_diff) && (q_diff > s_diff){
        q = -r-s;
	} else if(r_diff > s_diff){
        r = -q-s;
	} else {
        s = -q-r;
	}
	return vect3(q, r, s);
}
function axial_round(hex){
	return cube_to_axial(cube_round(axial_to_cube(hex)));
}
function cube_lerp(v0, v1, t){
	return vect3(lerp(v0[1], v1[1], t),
				 lerp(v0[2], v1[2], t),
				 lerp(v0[3], v1[3], t));
}

//--// movement range
function hex_in_radius(vect, rad){
	// vect is the axial coordinates to use as the center point
	// rad is the radius from the center to check for
	var arr = [], q=0, r=0;
	for(q=-rad;q<=rad;q++)
	{
		for(r=max(-rad, -q-rad); r<=min(rad, -q+rad); r++)
		{
			array_push(arr, vect_add(vect, [2, q, r]));
		}
	}
	return array_length(arr) == 0 ? -1 : arr;
}
function hex_in_intersection(vec0, rad0, vec1, rad1){
	// vect is the axial coordinates to use as the center point
	// rad is the radius from the center to check for
	var arr = [], q=0, r=0;
	var qmin = max(vec0[1]-rad0, vec1[1]-rad1);
	var qmax = min(vec0[1]+rad0, vec1[1]+rad1);
	var rmin = max(vec0[1]-rad0, vec1[2]-rad1);
	var rmax = min(vec0[1]+rad0, vec1[2]+rad1);
	var smin = -qmin-rmin;
	var smax = -qmax-qmax;
	for(q=qmin;q<=qmax;q++)
	{
		for(r=max(rmin, -q-smax); r<=min(rmax, -q+smin); r++)
		{
			array_push(arr, [2, q, r]);
		}
	}
	return array_length(arr) == 0 ? -1 : arr;
}

//--// misc conversion functions
function hex_to_pixel(hex, size, tile_type=POINTYTOP){
	if(tile_type == POINTYTOP)
	{
		return vect2(size*(sqrt(3)*hex[1] + sqrt(3)*hex[2]/2),
					 size*(3*hex[2]/2));
	} else {
		return vect2(size*(3*hex[1]/2),
					 size*(sqrt(3)*hex[1]/2 + sqrt(3)*hex[2]));
	}
}
function pixel_to_hex(point, size, tile_type=POINTYTOP){
	if(tile_type == POINTYTOP)
	{
		var v = vect2((sqrt(3)/3*point[1] - point[2]/3)/size,
					 (2*point[2])/(3*size));
	} else {
		var v = vect2((2*point[1]) / (size*3),
					 (-point[1]/3 + sqrt(3)*point[2]/3) / size);
	}
	return axial_round(v);
}
function cube_to_axial(cube_vect){
	var q = cube_vect[1];
	var r = cube_vect[2];
	return vect2(q, r);
}
function axial_to_cube(hex_vect){
	var q = hex_vect[1];
	var r = hex_vect[2];
	var s = -q-r;
	return vect3(q, r, s);
}

//--// extra functionality, for specific game purpose

function InstanceMoveToHex(_id, ){

}
