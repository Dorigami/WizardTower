/// @description 
/*
    var _struct = {
		xx : _xx,
		yy : _yy,
        type_string : _type_string,
        object : _object,
		size : _size,
        sprite_index : object_get_sprite(_object),
		mask_index : object_get_sprite(_object),
        faction : faction
    }
*/

cantplace = false;
hex = vect2(0,0);
hex_index = undefined;

position_update_timer = -1;
position_update_time = 3;
for(var i=0;i<size[0];i++)
{
	node_grid = []
}
function CheckPlacement(){
	// check the hex grid for structures or enemies
	with(global.i_hex_grid)
	{
		var _container = hexarr_containers[other.hex_index];
		var _inst = noone;
		for(var i=0;i<ds_list_size(_container);i++)
		{
			_inst = _container[| i];
			if(is_undefined(_inst)) continue; // ignore
			if(!is_undefined(_inst.structure)) return true; // bad placement
			if(_inst.faction == ENEMY_FACTION) return true; // bad placement
		}
	}
	return false; // good placement
}

if(!object_exists(object)) instance_destroy();


