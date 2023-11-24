/// @description Insert description here
// You can write your code in this editor

if(room != rHexTest)
{
	show_debug_message("o_hex_grid: wrong room, grid is destroyed");
	instance_destroy();
} else {
	show_debug_message("o_hex_grid: room is correct");
}

// hex map variables
hex_hash_loaded_file_name = "";
hex_hash_table = ds_map_create();


/*
	ds map : store index for each hex node
*/



function calc_hex_corner(center, i){
	// center is a vector2 of the center of the hexagon

    var angle_deg = 60 * i - (30*hex_type); // will offset angle when pointy-top is used
    var angle_rad = pi / 180 * angle_deg;
    return vect2(center[1] + hex_size * cos(angle_rad), center[2] + hex_size * sin(angle_rad))
}


//--// direction & neighbors
function axial_direction(_ind){
	return axial_direction_vectors[_ind];
}

function axial_neighbor(hex_vect, dir_index){
	return vect_add(hex_vect, axial_direction_vectors[dir_index]);
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
		arr[i] = cube_round(cube_lerp(cube0, cube1, i/n));
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
function hex_to_pixel(hex){
	if(hex_type == POINTYTOP)
	{
		return vect2(hex_size*(sqrt(3)*hex[1] + sqrt(3)*hex[2]/2),
					 hex_size*(3*hex[2]/2));
	} else {
		return vect2(hex_size*(3*hex[1]/2),
					 hex_size*(sqrt(3)*hex[1]/2 + sqrt(3)*hex[2]));
	}
}
function pixel_to_hex(point){
	if(hex_type == POINTYTOP)
	{
		var v = vect2((sqrt(3)/3*point[1] - point[2]/3)/hex_size,
					 (2*point[2])/(3*hex_size));
	} else {
		var v = vect2((2*point[1]) / (hex_size*3),
					 (-point[1]/3 + sqrt(3)*point[2]/3) / hex_size);
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
function hex_create(q, r){
	var _node = new HexNode(self, q, r);
}

function hex_get(hex_vect){
}



