/// @description 

if(other.id == destination_) 
{
	var _dist = point_distance(x,y,other.x,other.y);
	
	// set target if following an enemy
	if(other.follow_ != noone && !is_undefined(other.follow_))
	{
		target_ = other.follow_;
	}
	
	// arrive on point
	if(_dist <= 5)
	{
		x = other.x;
		y = other.y;
		instance_destroy(destination_);
		destination_ = noone;
		speed = 0;
	}
}
