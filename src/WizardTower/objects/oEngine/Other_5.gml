/// @description 

// destroy the temporary tile layer
if(layer_tilemap_exists(temp_layer, global.terrain_tiles)){
	layer_tilemap_destroy(global.terrain_tiles);
	layer_destroy(temp_layer);
	global.terrain_tiles = -1;
}
if(layer_tilemap_exists(fog_of_war_layer, global.fog_of_war)){
	layer_tilemap_destroy(global.fog_of_war);
	layer_destroy(fog_of_war_layer);
	global.fog_of_war = -1;
}
