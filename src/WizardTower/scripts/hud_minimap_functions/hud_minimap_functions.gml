
function minimap_pull_hex_data(){

}
function minimap_determine_node_color(_data, _index=-1){
	with(global.iHUD)
	{
		if(is_undefined(_data)) || (!instance_exists(_data)){
			if(global.i_hex_grid.hexarr_is_goal[_index])
			{
				return minimap_color_goal;
			} else if(global.i_hex_grid.hexarr_is_spawn[_index]){
				return minimap_color_spawn;
			}
			return minimap_color_background;
		} else {
			// case: there is an enitiy at this node.
			//       determine color based on faction
			if(_data.faction == PLAYER_FACTION){
				return minimap_color_friendly;
			} else if(_data.faction == NEUTRAL_FACTION){
				return minimap_color_neutral;
			} else {
				return minimap_color_enemy;
			}
			
		}
	}
}
