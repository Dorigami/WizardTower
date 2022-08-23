/// @description Initialize UI

// Inherit the parent event
event_inherited();
// UI functions
function ToggleInventory(){
	if(instance_exists(oInventory))
	{
		with(oInventory) instance_destroy();
	} else {
		with(instance_create_depth(xTrue,yTrue,UI_DEPTH,oInventory))
		{
			y -= height;
			camX = x - camera_get_view_x(view_camera[0]);
			camY = y - camera_get_view_y(view_camera[0])
		}
	}
}

cam = view_camera[0];
viewWidthHalf = 0.5*camera_get_view_width(cam);
viewHeightHalf = 0.5*camera_get_view_height(cam);
fadeIn = false;
fullLog = "";
partialLog = "";
logDisplayLimit = 5
image_alpha = 0;
image_xscale = RESOLUTION_W / sprite_width;
image_yscale = RESOLUTION_H / sprite_height;
// show_debug_message("xscale = " + string(image_xscale) + "\nyscale = " + string(image_yscale));

var _control = undefined;
var _x = x+16;
var _y = y+280;
// set to melee
_control = ButtonAdd(_x,_y,id,ds_list_size(controlsList),"openInventory",sBtnInventory,,ToggleInventory,-1);
// set to melee
_x += 0; _y += 33;
_control = ButtonAdd(_x,_y,id,ds_list_size(controlsList),"meleeAction",sBtnAction,,ToggleAction,[ACTION.MELEE, SLOT.WEAPON]);
// set to ranged
_x += 33; _y += 0;
_control = ButtonAdd(_x,_y,id,ds_list_size(controlsList),"rangedAction",sBtnAction,,ToggleAction,[ACTION.RANGED, SLOT.WEAPON]);
// set to spell
_x += 33; _y += 0;
_control = ButtonAdd(_x,_y,id,ds_list_size(controlsList),"spellAction",sBtnAction,,ToggleAction,[ACTION.SPELL, SLOT.WEAPON]);


