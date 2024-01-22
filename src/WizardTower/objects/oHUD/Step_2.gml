/// @description 

with(global.iCamera)
{
	other.xx = (x-global.game_grid_bbox[0]) div GRID_SIZE;
	other.yy = (y-global.game_grid_bbox[1]) div GRID_SIZE;
}

zoom = global.iEngine.view_zoom;
var _halfview_w = global.game_grid_width * minimap_tile_size * (global.iCamera.viewWidthHalf / ((global.game_grid_width div 2)*GRID_SIZE))/2;
var _halfview_h = global.game_grid_height * minimap_tile_size * (global.iCamera.viewHeightHalf / ((global.game_grid_height div 2)*GRID_SIZE))/2;

if(enable_minimap)
{
	minimap_view_bbox[0] = ox + xx*minimap_tile_size - _halfview_w;
	minimap_view_bbox[1] = oy + yy*minimap_tile_size - _halfview_h;
	minimap_view_bbox[2] = ox + xx*minimap_tile_size + _halfview_w;
	minimap_view_bbox[3] = oy + yy*minimap_tile_size + _halfview_h;
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