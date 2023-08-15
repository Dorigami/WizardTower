function CreateFloatNumber(_x,_y,_value,_type,_direction=0,_delay=-1,_rate=0.03){
	var _struct = 	{
		value : _value,
		type : _type,
		direction : _direction,
		decayRate : _rate,
		decayDelay : _delay
	}
	instance_create_layer(_x,_y,"Instances",oFloatNumber,_struct);
}