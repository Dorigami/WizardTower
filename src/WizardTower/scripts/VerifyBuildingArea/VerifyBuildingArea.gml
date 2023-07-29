function VerifyBuildingArea(_x, _y, _w, _h){
	var _cw = _w div 2;      // center width
	var _ch = _h div 2;      // center height 
	var _valid = true, _node = undefined, i, j;
	var _xx = (_x - global.game_grid_xorigin) div GRID_SIZE;
	var _yy = (_y - global.game_grid_yorigin) div GRID_SIZE;
	// loop through each node, check if occupied, also check if blocked
	for(i=-_cw; i<_w-_cw; i++){
	for(j=-_ch; j<_h-_ch; j++){
		if(!point_in_rectangle(_xx+i, _yy+j, 0, 0, global.game_grid_width-1, global.game_grid_height-1)){
			show_debug_message("FAILURE - verify build area - a point is not in game grid");
			return false;
		} else {
			_node = global.game_grid[# _xx+i, _yy+j];
			if(ds_list_size(_node.occupied_list) > 0) || (_node.blocked){
				show_debug_message("FAILURE - verify build area - a point is occupied or blocked | occupied size = {0} & blocked = {1}", ds_list_size(_node.occupied_list), _node.blocked);
				return false;
			}
		}
	}}
}