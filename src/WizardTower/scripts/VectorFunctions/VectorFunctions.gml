function speed_dir_to_vect2(_speed,_direction){
	//returns a vect2 with the given arguments.
	var _x = lengthdir_x(argument[0],argument[1]);
	var _y = lengthdir_y(argument[0],argument[1]);

	return(vect2(_x,_y));
}
function vect_add(_vect1, _vect2){
	//adds each component of vect1 with each component of vect2
	var i;
	var v1 = argument0;
	var v2 = argument1;
	var v;
	if(!is_array(v1)) || (!is_array(v2)) return -1;
	var num = min(v1[0],v2[0]);
	v[0] = num;
	for(i=1; i<= num; i++)
	{
	    v[i] = v1[i]+v2[i];
	}
	return v;
}
function vect_comp(vect1, vect2){
	//compares each component of vect1 with each component of vect2
	//returns true if same
	var i;
	var v1 = argument0;
	var v2 = argument1;
	var truect = 0;

	var num = min(v1[0],v2[0]);

	for(i=1; i<= num; i++)
	{
	    truect+= v1[i]==v2[i];
	}
	return truect == max(v1[0],v2[0]);
}
function vect_cross(vect1,vect2){
	//returns the cross product between vect1 and vect2
	var i;
	var v1 = argument0;
	var v2 = argument1;

	var num = min(v1[0],v2[0]);
	if(num ==2)
	{
	    var v3 = vect_cross(vect3(v1[1],v1[2],1),vect3(v2[1],v2[2],1));
	    v3[0] = 2;
	    return v3;
	}
	else if (num ==3)
	{
	    return vect3(v1[2] * v2[3] - v1[3] * v2[2], v1[3] * v2[1] - v1[1] * v2[3],v1[1] * v2[2] - v1[2] * v2[1]);
	}
	else
	{
	    show_debug_message("vect_cross todo vect4")
	    return vect4(0,0,0,0);
	}
	return 0;
}
function vect_proj(vect_from, vect_onto){
	// get component of u, projected onto v
	var u = vect_from;
	var v = vect_onto;
	var len = vect_len(u);
	var vn = vect_norm(v);
	var un = vect_norm(u);
	return vect_multr(vn, len*vect_dot(un,vn));
}
function vect_direction(vector){
	//returns direction of given vector
	var _vec=argument[0];
	if(_vec[1]==0 && _vec[2]==0)
	    return(-1);
	else
	    return(point_direction(0,0,_vec[1],_vec[2]));
}
function vect_dist(vect1,vect2){
	//returns the distance between vect1 and vect2
	var i;
	var v1 = argument0;
	var v2 = argument1;

	var num = min(v1[0],v2[0]);
	var tot = 0;
	for(i=1; i<= num; i++)
	{
	    tot+=v1[i]*v1[i] + v2[i] * v2[i];
	}
	if(tot != 0)
	{
	    tot = sqrt(tot);
	}
	return tot;
}
function vect_div(vect1, vect2){
	//divide each component of vect1 by each component of vect2
	var i;
	var v1 = argument0;
	var v2 = argument1;
	var v;

	var num = min(v1[0],v2[0]);
	v[0] = num;
	for(i=1; i<= num; i++)
	{
	    v[i] = v1[i]/v2[i];
	}
	return v;
}
function vect_divr(vect, real){
	//divides each component of vect by the value specified

	var i;
	var v1 = argument0;
	var r = argument1;
	var v;

	var num = v1[0];
	v[0] = num;
	for(i=1; i<= num; i++)
	{
	    v[i] = v1[i]/r;
	}
	return v;
}
function vect_dot(vect1,vect2){
	//returns the dot product between vect1 and vect2
	var i;
	var v1 = argument0;
	var v2 = argument1;

	var num = min(v1[0],v2[0]);
	var tot = 0;
	for(i=1; i<= num; i++)
	{
	    tot+=v1[i] * v2[i];
	}

	return tot;
}
function vect_len(vect){
	//returns the length of a scalar 
	var i;
	var v1 = argument0;

	var num = v1[0];
	var tot = 0;
	for(i=1; i<= num; i++)
	{
	    tot+=v1[i]*v1[i];
	}
	if(tot != 0)
	{
	    tot = sqrt(tot);
	}
	return tot;
}
function vect_mult(vect1, vect2){
	//multiplies each component of vect1 with each component of vect2

	var i;
	var v1 = argument0;
	var v2 = argument1;
	var v;

	var num = min(v1[0],v2[0]);
	v[0] = num;
	for(i=1; i<= num; i++)
	{
	    v[i] = v1[i]*v2[i];
	}
	return v;
}
function vect_multr(vect, real){
	//multiplies each component of vect by the value specified

	var i;
	var v1 = argument0;
	var r = argument1;
	var v;

	var num = v1[0];
	v[0] = num;
	for(i=1; i<= num; i++)
	{
	    v[i] = v1[i]*r;
	}
	return v;
}
function vect_norm(vect){
	//normalises a scalar to vector 
	var i;
	var v1 = argument0;
	var v;

	var num = v1[0];
	var tot = 0;
	v[0] = num;
	for(i=1; i<= num; i++)
	{
	    v[i] = 0;
	    tot+=v1[i]*v1[i];
	}
	if(tot != 0)
	{
	    tot = sqrt(tot);
	    for(i=1; i<= num; i++)
	    {
	        v[i] = v1[i]/tot;
	    }
	}
	return v;
}
function vect_perp(vect){
	//perpendicular vector for the vector

	var i;
	var v1 = argument0;
	var v;

	var num = v1[0];
	v[0] = num;
	if(num ==2)
	{
	    v[1] = -v1[2];
	    v[2] = v1[1];
	}
	else if(num ==3)
	{
	    v = vect3(0,0,0);
	    show_debug_message("vect_perp, todo vect3")
	}
	else
	{
	    v = vect4(0,0,0,0);
	    show_debug_message("vect_perp, todo vect4")
	}

	return v;
}
function vect_rev(vect){
	//reverse direction for the vector

	var i;
	var v1 = argument0;
	var v;

	var num = v1[0];
	var tot = 0;
	v[0] = num;
	for(i=1; i<= num; i++)
	{
	    v[i] = -v1[i];
	}

	return v;
}
function vect_scaler(vect,real){
	//scales the vector to the distance specified

	var i;
	var v1 = vect_norm(argument[0]);
	var scale = argument[1];
	var v;

	var num = v1[0];
	var tot = 0;
	v[0] = num;
	for(i=1; i<= num; i++)
	{
	    v[i] = v1[i]*scale;
	}

	return v;
}
function vect_subtract(vect1, vect2){
	//Subtracts each component of vect2 from each component of vect1
	var i;
	var v1 = argument[0];
	var v2 = argument[1];
	var v;

	var num = min(v1[0],v2[0]);
	v[0] = num;
	for(i=1; i<= num; i++)
	{
	    v[i] = v1[i]-v2[i];
	}
	return v;
}
function vect_to_vect2(vect){
	//converts vect to a vect2

	var i;
	var v1 = argument0;
	var v;

	var num = min(v1[0],2);
	v[0] = num;
	v[1] = 0;
	v[2] = 0;
	for(i=1; i<= num; i++)
	{
	    v[i] = v1[i];
	}
	return v;
}
function vect_to_vect3(vect){
	//converts vect to a vect3

	var i;
	var v1 = argument0;
	var v;

	var num = min(v1[0],3);
	v[0] = num;
	v[1] = 0;
	v[2] = 0;
	v[3] = 0;
	for(i=1; i<= num; i++)
	{
	    v[i] = v1[i];
	}
	return v;
}
function vect_to_vect4(vect){
	//converts vect to a vect4

	var i;
	var v1 = argument0;
	var v;

	var num = min(v1[0],4);
	v[0] = num;
	v[1] = 0;
	v[2] = 0;
	v[3] = 0;
	v[4] = 0;
	for(i=1; i<= num; i++)
	{
	    v[i] = v1[i];
	}
	return v;
}
function vect_truncate(vector,max_length){
	//if the vector exceeds the max length, it will be returned truncated to max length.
	var _vec=argument[0];
	var _len=argument[1];

	if(vect_len(_vec)>_len)
	    _vec=vect_scaler(_vec,_len);

	return(_vec);
}
function vect2(x,y){
	//creates a 2d vector
	//usage
	// v = vect2(10,10)
	// num_components = v[0]; // == 2
	// x = v[1];
	// y = v[2];

	var v;
	v[0] = 2;
	v[1] = argument0;
	v[2] = argument1;
	return v;
}
function vect3(x,y,z){
	//creates a 3d vector
	//usage
	// v = vect3(10,10,10)
	// num_components = v[0]; // == 3
	// x = v[1];
	// y = v[2];
	// z = v[3];
	var v;
	v[0] = 3;
	v[1] = argument0;
	v[2] = argument1;
	v[3] = argument2;
	return v;
}
function vect4(x,y,z,a){
	//creates a 4d vector
	//usage
	// v = vect4(10,10,10,10)
	// num_components = v[0]; // == 4
	// x = v[1];
	// y = v[2];
	// z = v[3];
	// a = v[4];
	var v;
	v[0] = 4;
	v[1] = argument0;
	v[2] = argument1;
	v[3] = argument2;
	v[4] = argument3;
	return v;
}
function vect_intersection(x1, y1, dx1, dy1, x2, y2, dx2, dy2){
	// _p1 is the starting point for the first vector               ex: [x, y]
	// _v1 is the first vector2, representing a line segment        ex: [len, x, y]
	// _p2 is the starting point for the second vector              ex: [x, y]
	// _v2 is the second vector2, representing another line segment ex: [len, x, y]
	
	// returns a vector representing the distance to the intersection along _v1
	
	if(_v1[1] - _v2[1] > 0) && (_v1[2] - _v2[2] > 0)
	{
		// t2 is normalised distance from line segment start to line segment end of intersect point
		// float t2 = (rdx * (e2.sy - oy) + (rdy * (ox - e2.sx))) / (sdx * rdy - sdy * rdx);
		var _t2 = (_v1[1]*(_p2[1] - _p1[1]) + (_v1[2] * (_p1[0] - _p2[0]))) / (_v2[1]*_v1[2] - _v2[2]*_v1[1]);
	
		// t1 is normalised distance from source along ray to ray length of intersect point
		//float t1 = (e2.sx + sdx * t2 - ox) / rdx;	
		var _t1 = (_p2[0] + _v2[1] * _t2 - _p1[0]) / _v1[1];
		
		// If intersect point exists along ray, and along line 
		// segment then intersect point is valid
		if(_t1 > 0) && (_t2 >= 0) && (_t2 < 1)
		{
		
		}
	}
	
	var rtn = undefined;
	


	
	return rtn
}
function vect_does_intersect(x1, y1, dx1, dy1, x2, y2, dx2, dy2){
	var rtn = false, t1=0, t2=0;

	if(abs(dx2 - dx1) == 0) || (abs(dy2 - dy1) == 0) return false;

	// float t2 = (rdx * (e2.sy - oy) + (rdy * (ox - e2.sx))) / (sdx * rdy - sdy * rdx);
	t2 = (dx1*(y2-y1) + (dy1*(x1-x2))) / (dx2*dy1 - dy2*dx1);
	//float t1 = (e2.sx + sdx * t2 - ox) / rdx;	
	t1 = (x2 + dx2*t2 - x1) / dx1;

	if(t1 >= 0) && (t1 <= 1) && (t2 >= 0) && (t2 <= 1)
	{
		return true;
	} else {
		return false;
	}
}
