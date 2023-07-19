/// @description 

var _node=undefined;

var color_background = c_black;
var color_view = c_black;
var color_null = c_white;
var color_neutral = c_teal;
var color_friendly = c_green;
var color_enemy = c_red;


draw_set_color(color_background);
draw_rectangle(ox-1,oy-1,ox+global.game_grid_width,oy+global.game_grid_height,false);
for(var i=0;i<global.game_grid_width;i++){
for(var j=0;j<global.game_grid_height;j++){
	_node = global.game_grid[# i, j];
	if(ds_list_size(_node.occupied_list) == 0)
	{
		draw_set_color(color_null);
	} else {
		if(_node.occupied_list[| 0].faction == PLAYER_FACTION)
		{
			draw_set_color(color_friendly);
		} else {
			draw_set_color(color_enemy);
		}
	}
	draw_rectangle(ox+i,oy+j,ox+i,oy+j,false)
}}

draw_set_color(color_view);
draw_rectangle(view_bbox.x1, view_bbox.y1, view_bbox.x2, view_bbox.y2, true);
// show_debug_message("view_bbox = [{0}, {1}, {2}, {3}]", view_bbox.x1, view_bbox.y1, view_bbox.x2, view_bbox.y2);
