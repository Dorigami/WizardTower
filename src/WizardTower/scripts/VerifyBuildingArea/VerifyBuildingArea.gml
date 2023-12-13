function VerifyBuildingArea(_x, _y){
	var _valid = true, i;
	var _xx = (_x - global.game_grid_bbox[0]) div GRID_SIZE;
	var _yy = (_y - global.game_grid_bbox[1]) div GRID_SIZE;
	
	with(global.i_hex_grid)
	{
		// get hex data
		var _hex = pixel_to_hex(vect2(_x,_y));
		var _hex_index = hex_get_index(_hex);
		// validate the hex data
		if(is_undefined(_hex_index)) return false;
		if(!hexarr_enabled[_hex_index]) return false;
		// get the container for the hex node
		var _container = hexarr_containers[_hex_index]; 
	}
	
	// loop through entities occupying the node
	var _inst = noone;
	for(i=0; i<ds_list_size(_container); i++)
	{
		_inst = _container[| i];
		if(!is_undefined(_inst.blueprint)) return false;
		if(!is_undefined(_inst.structure)) return false;
		if(_inst.faction == ENEMY_FACTION) return false;
	}
	
	return true;
}