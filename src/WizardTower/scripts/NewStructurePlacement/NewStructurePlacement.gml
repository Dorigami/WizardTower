function NewStructurePlacement(_obj){
	EmptySelection();
	with(global.iPlayer)
	{
		if(target != noone) && (instance_exists(target)) instance_destroy(target);
		with(instance_create_layer(mouse_x,mouse_y,"Instances",_obj))
		{
			other.target = id;
			other.controlScheme = ControlSchemeStructurePlacement;
		}
	}
}