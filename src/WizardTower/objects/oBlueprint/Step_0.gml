/// @description 


if(global.iEngine.blueprint_instance != id) exit;

var _x = 0;
var _y = 0;
with(o_hex_grid)
{
	if(!is_undefined(mouse_hex_index)) && (!array_equals(other.hex,mouse_hex_coord))
	{
		other.hex = mouse_hex_coord;
		other.hex_index = mouse_hex_index;
		other.x = mouse_hex_pos[1];
		other.y = mouse_hex_pos[2];
		with(other){ cantplace = CheckPlacement(); }
	}
}

/*

// move blueprint with the mouse, but lock it to grid cells
if(!is_undefined(hex_index))
{
	var _cw = size[0] div 2;      // center width
	var _ch = size[1] div 2;      // center height 

	rect = [
		global.game_grid_bbox[0] + (hex[1]-_cw)*GRID_SIZE,
		global.game_grid_bbox[1] + (hex[2]-_ch)*GRID_SIZE,
		global.game_grid_bbox[0] + (hex[1]-_cw+size[0])*GRID_SIZE - 1,
		global.game_grid_bbox[1] + (hex[2]-_ch+size[1])*GRID_SIZE - 1
	];

	cantplace = CheckPlacement();
}
