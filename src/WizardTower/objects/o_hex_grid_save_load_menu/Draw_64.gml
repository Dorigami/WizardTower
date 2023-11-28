/// @description 


draw_set_color(c_black);
draw_set_alpha(1);
draw_rectangle(menu_bbox[0],menu_bbox[1]-14,menu_bbox[2],menu_bbox[3],false);
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_set_color(c_aqua);
draw_text(menu_bbox[0]+2,menu_bbox[1],"HEX MAP SAVE/LOAD MENU  -  Currently Loaded: " + global.i_hex_grid.hexmap_loaded_filename);

for(var i=ds_list_size(button_list)-1; i>=0; i--){
	button_list[| i].draw();
}

for(var i=ds_list_size(option_list)-1; i>=0; i--){
	option_list[| i].draw();
}










