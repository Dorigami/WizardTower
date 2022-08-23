/// @description 
// follow camera
x = camera_get_view_x(view_camera[0]);// global.iCamera.x-viewWidthHalf;
y = camera_get_view_y(view_camera[0]);//global.iCamera.y-viewHeightHalf;
// Inherit the parent event
event_inherited();

if(fadeIn)
{
	// fade in
	if(image_alpha != 1) image_alpha = min(1, image_alpha + 0.01);
}
with(global.iGame)
{
	if(pInp_modeMeleeCheck)
	{
		var _btn = other.controlsList[| other.controlsMap[? "meleeAction"]];
		if(_btn.enabled)
		{
			_btn.pressed = true;
			_btn.image = 2;
		}
	}
	if(pInp_modeMelee)
	{
		var _btn = other.controlsList[| other.controlsMap[? "meleeAction"]];
		if(_btn.enabled)
		{
			_btn.activated = true;
		}
	}
	if(pInp_modeRangedCheck)
	{
		var _btn = other.controlsList[| other.controlsMap[? "rangedAction"]];
		if(_btn.enabled)
		{
			_btn.pressed = true;
			_btn.image = 2;
		}
	}
	if(pInp_modeRanged)
	{
		var _btn = other.controlsList[| other.controlsMap[? "rangedAction"]];
		if(_btn.enabled)
		{
			_btn.activated = true;
		}
	}
	if(pInp_modeSpellCheck)
	{
		var _btn = other.controlsList[| other.controlsMap[? "spellAction"]];
		if(_btn.enabled)
		{
			_btn.pressed = true;
			_btn.image = 2;
		}
	}
	if(pInp_modeSpell)
	{
		var _btn = other.controlsList[| other.controlsMap[? "spellAction"]];
		if(_btn.enabled)
		{
			_btn.activated = true;
		}
	}
	if(pInp_inventoryCheck)
	{
		var _btn = other.controlsList[| other.controlsMap[? "openInventory"]];
		if(_btn.enabled)
		{
			_btn.pressed = true;
			_btn.image = 2;
		}
	}
	if(pInp_inventory)
	{
		var _btn = other.controlsList[| other.controlsMap[? "openInventory"]];
		if(_btn.enabled)
		{
			_btn.activated = true;
		}
	}
}
