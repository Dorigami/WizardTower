function CreateButton(_obj,_sprite,_x=0,_y=0,_text="sample text",_gui=false,_rightScript=-1,_rightArgs=-1,_leftScript=-1,_leftArgs=-1){
	with(instance_create_layer(_x,_y,"Instances",_obj))
	{
		sprite_index = _sprite;
		text = _text;
		gui = _gui;
		leftScript = _leftScript;
		leftArgs = _leftArgs;
		rightScript = _rightScript;
		rightArgs = _rightArgs;
		return id;
	}
}