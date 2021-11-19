/// @description Control Selection Painter

len_ = point_distance(x,y,mouse_x,mouse_y);
dir_ = point_direction(x,y,mouse_x,mouse_y);

image_xscale = lengthdir_x(len_, dir_);
image_yscale = lengthdir_y(len_, dir_);

visible = len_ >= 5 ? true : false;

// update unit selection
if(mouse_check_button_released(mb_left))
{
	var _size = 0;
	EmptySelection();
	if(visible)
	{	
		instance_place_list(x,y,oWizard,global.unitSelection,false);
		// check the faction of each unit that has been selected
		_size = ds_list_size(global.unitSelection);
		if(_size > 0)
		{
			for(var i=_size-1;i>=0;i--)
			{
				var _inst = global.unitSelection[| i];
				if(!is_undefined(_inst)) && (!_inst.active)
				{
					ds_list_delete(global.unitSelection,ds_list_find_index(global.unitSelection, _inst));
				}
			}
		}
	} else {
		var _inst = instance_place(x,y,oWizard);
		if(_inst != noone) && (_inst.active)
		{
			// select a unit
			ds_list_add(global.unitSelection,_inst);
		} else {
			// select a structure or resource (open their respective radial menu)
			_inst = instance_place(x,y,pStructure);
			if(_inst == noone) _inst = instance_place(x,y,pResource);
			if(_inst != noone) && (_inst.radialOptions != -1)
			{
				_inst.openRadial = true;			
			}
		}
	}
	// set "selected" variable
	_size = ds_list_size(global.unitSelection);
	if(_size > 0)
	{
		for(var i=0; i<_size; i++)
		{
			global.unitSelection[| i].selected = true;
		}
	}
	instance_destroy();
}
