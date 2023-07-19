/// @description clean up density map at begin step


// clean out the density maps
for(var i=0; i<ds_list_size(faction_entity_density_maps); i++) ds_grid_clear(faction_entity_density_maps[| i], 0);

