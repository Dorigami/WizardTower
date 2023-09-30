/// @description 
draw_set_alpha(1);
draw_set_color(c_black);
draw_set_font(fDefault)
draw_set_halign(fa_center);


/*

draw_set_valign(fa_middle);
var _str = "";
for(var i=0; i<global.game_grid_width; i++){
for(var j=0; j<global.game_grid_height; j++){
	var _node = global.game_grid[# i, j];
	_str = string(_node.walkable) + "\nct: " + string(ds_list_size(_node.occupied_list))
	
	draw_text(_node.x,_node.y,_str);
}}

