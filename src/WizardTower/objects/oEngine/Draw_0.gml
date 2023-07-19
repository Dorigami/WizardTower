/// @description 
draw_set_alpha(1);
draw_set_color(c_black);
draw_set_font(fDefault)
draw_set_halign(fa_center);




draw_set_valign(fa_middle);
for(var i=0; i<global.game_grid_width; i++){
for(var j=0; j<global.game_grid_height; j++){
	var _node = global.game_grid[# i, j];
	var _grid = faction_entity_density_maps[| ENEMY_FACTION];
	draw_text(_node.x, _node.y, "dn="+string(round(_grid[# i, j])));

	if(is_instanceof(_node, Node))
	{
		// draw_text(_node.x, _node.y, string(ds_list_size(_node.occupied_list)));
		
		/*
		if(_node.path_flow_dir != 0)
		{
			draw_arrow(_node.x, _node.y, _node.x+(_node.path_flow_dir[1]*16), _node.y+(_node.path_flow_dir[2]*16), 10)
		}
		*/
		
		// draw_text(_node.x, _node.y, string(_node.path_cost));
	}
}}
