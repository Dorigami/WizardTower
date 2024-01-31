function CreateFloatNumber(_x,_y,_value,_type,_font=fFloatText,_direction=0,_delay=-1,_rate=0.03,_gui=false){
	var _struct = 	{
		value : _value,
		type : _type,
		font : _font,
		direction : _direction,
		decayRate : _rate,
		decayDelay : _delay,
		gui : _gui
	}
	return instance_create_layer(_x,_y,"Instances",oFloatNumber,_struct);
}