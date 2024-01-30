/// @description 
with(global.iCamera)
{
	other.xx = (x-global.game_grid_bbox[0]) div GRID_SIZE;
	other.yy = (y-global.game_grid_bbox[1]) div GRID_SIZE;
}

zoom = global.iEngine.view_zoom;
var _halfview_w = global.game_grid_width * minimap_tile_size * (global.iCamera.viewWidthHalf / ((global.game_grid_width div 2)*GRID_SIZE))/2;
var _halfview_h = global.game_grid_height * minimap_tile_size * (global.iCamera.viewHeightHalf / ((global.game_grid_height div 2)*GRID_SIZE))/2;

if(minimap_needed)
{
	// calculate the positions of each hex node, translated to the minimap size
	var _size = array_length(global.i_hex_grid.hexarr_hexes);
	var _width = global.i_hex_grid.hexgrid_width_max*2;
	var _height = (global.i_hex_grid.hexgrid_height_max*2)-1;
	// the scale of the tiles displayed on the minimap must also be calculated
	minimap_scale = min(5.8,minimap_width/_width, minimap_height/_height);
	show_debug_message("the new scale is = {0}", minimap_scale);
	// calculate the top-left position for the minimap tiles
	var _width_offset = _width div 2;
	var _height_offset = _height div 2;
	var xorigin = minimap_centerx - _width_offset*minimap_scale;
	var yorigin = minimap_centery - _height_offset*minimap_scale;
	var _hex;
	array_resize(minimap_hex_pos, _size);
	array_resize(minimap_hex_colors, _size);
	array_resize(minimap_hex_container_check, _size);
	
	for(var i=0;i<_size;i++)
	{
		// reset color values for the hex nodes
		minimap_hex_colors[i] = minimap_color_background;
		// get the axial coord of the current hex node
		_hex = global.i_hex_grid.hexarr_hexes[i];
		if(global.i_hex_grid.hexarr_enabled[i]){
			// calulate the draw position needed for this hex node
			// this is weird math that i just guess-and-checked until the positions worked
			minimap_hex_pos[i] = vect2(
				xorigin + ((_hex[1]*2 + _hex[2]%2) + (2*(_hex[2] div 2)))*minimap_scale,
				yorigin + (_hex[2]*2)*minimap_scale);
		} else {
			// set to -1 so the draw event ignores this hex node
			minimap_hex_pos[i] = -1;
		}
	}

	
	// the 'minimap_needed' flag is not set to false until the sprite is created in the draw event
}

if(enable_minimap)
{
//--// show the players current view with respect to the map size
	//minimap_view_bbox[0] = ox + xx*minimap_tile_size - _halfview_w;
	//minimap_view_bbox[1] = oy + yy*minimap_tile_size - _halfview_h;
	//minimap_view_bbox[2] = ox + xx*minimap_tile_size + _halfview_w;
	//minimap_view_bbox[3] = oy + yy*minimap_tile_size + _halfview_h;
//--// determine the colors needed for each node of the map
	for(var i=0;i<array_length(minimap_hex_container_check);i++)
	{
		var _new_data = global.i_hex_grid.hexarr_containers[i][| 0];
		var _old_data = minimap_hex_container_check[i];
		if(_new_data != _old_data)
		{
			minimap_hex_container_check[i] = _new_data;
			// update the check variable, then adjust the minimap hex color according to the new data
			minimap_hex_colors[i] = minimap_determine_node_color(_new_data, i);
		}
	}
}
player_data_string = "";
with(global.iEngine.player_actor)
{
	// show player health
	other.player_data_string += "HEALTH: " + string(health) + "\n";
	// show unit supply
	other.player_data_string += "SUPPLY: " + string(supply_current+supply_in_queue) + " / " + string(supply_limit) + "\n";
	// show available material
	other.player_data_string += "MONEY: "+string(material)+"\n";
}
mouse_position_data_string = "mouse location = [" + string(mouse_x) + ", " + string(mouse_y) + "] [";
with(o_hex_grid)
{
	other.mouse_position_data_string += string(mouse_hex_coord[1]) + ", " + string(mouse_hex_coord[2]) + "]\n";
}