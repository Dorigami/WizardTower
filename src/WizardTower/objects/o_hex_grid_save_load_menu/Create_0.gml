/// @description 


function menu_update(){
	var _half_width = (max(option_width+(option_sep), ds_list_size(button_list)*(button_width+button_sep))+button_sep) div 2;
	var _half_height = ((button_height + (button_sep*2))+(ds_list_size(option_list)*(option_height+option_sep))+option_sep) div 2;
	menu_bbox[3] = y+_half_height;
	menu_bbox[2] = x+_half_width;
	menu_bbox[1] = y-_half_height;
	menu_bbox[0] = x-_half_width;
}
function update_options(){
	// clear existing options
	option_clicked = -1;
	while(ds_list_size(option_list) > 0)
	{
		delete option_list[| 0];
		ds_list_delete(option_list, 0);
	}
	// create the available options
	var arr = hex_map_get_saved_names();
	if(arr != -1){
		for(var i=0; i<array_length(arr); i++){
			var opt = new Option(arr[i], hex_map_saveload_menu_click_option, []);
			opt.init();
		}
	}
}

hexmap_directory = working_directory + "/hexhashtables/"
mouse_gui_x = device_mouse_x_to_gui(0);
mouse_gui_y = device_mouse_y_to_gui(0);
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();
menu_bbox = [0,0,0,0];

x = gui_width div 2;
y = gui_height div 2;

button_width = 60;
button_height = 20;
button_sep = 2;
option_width = 100;
option_height = 20;
option_sep = 2;
button_focus = -1;
option_focus = -1;
option_clicked = -1;

button_list = ds_list_create();
option_list = ds_list_create();

Button = function(_text, _scr, _args) constructor{
	index = 0;
	creator = noone
	c1 = c_aqua;
	c2 = c_white;
	text = _text;
	bbox = [0,0,0,0];
	width = 0;
	height = 0;
	xcenter = 0;
	ycenter = 0;
	effect_script = _scr;
	effect_script_args = _args;
	static init = function(){
		creator = o_hex_grid_save_load_menu.id;
		index = ds_list_size(o_hex_grid_save_load_menu.button_list);
		ds_list_add(o_hex_grid_save_load_menu.button_list, self);
		width = creator.button_width;
		height = creator.button_height;
	}
	static update = function(){
		bbox[0] = creator.menu_bbox[0] + creator.button_sep + (index*(width+creator.button_sep));
		bbox[2] = bbox[0]+width;
		bbox[1] = creator.menu_bbox[1]+creator.button_sep;
		bbox[3] = bbox[1]+height;
		xcenter = (bbox[2]+bbox[0]) div 2;
		ycenter = (bbox[3]+bbox[1]) div 2;
		if(point_in_rectangle(creator.mouse_gui_x,creator.mouse_gui_y,bbox[0],bbox[1],bbox[2],bbox[3]))
		{
			creator.button_focus = index;
			if(mouse_check_button_pressed(mb_left)){
				script_execute_array(effect_script,effect_script_args);
			}
		}
		
	}
	static draw = function(){
		draw_set_color(creator.button_focus == index ? c2 : c1);
		draw_rectangle(bbox[0],bbox[1],bbox[2],bbox[3],false)
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_color(c_black);
		draw_set_font(fDefault);
		draw_text(xcenter,ycenter,text);
	}
}

Option = function(_text, _scr, _args) constructor{
	index = 0;
	creator = noone
	c1 = c_ltgray;
	c2 = c_white;
	text = _text;
	bbox = [0,0,0,0];
	width = 0;
	height = 0;
	xcenter = 0;
	ycenter = 0;
	effect_script = _scr;
	effect_script_args = _args;
	static init = function(){
		creator = o_hex_grid_save_load_menu.id;
		index = ds_list_size(creator.option_list);
		ds_list_add(creator.option_list, self);
		width = max(creator.option_width, (creator.menu_bbox[2]-creator.menu_bbox[0])-creator.option_sep*2); // creator.option_width;
		height = creator.option_height;
		effect_script_args = [index];
	}
	static update = function(){
		bbox[0] = creator.menu_bbox[0] + creator.option_sep;
		bbox[2] = bbox[0]+width;
		bbox[1] = creator.menu_bbox[1] + (creator.button_sep*2 + creator.button_height) + (index*(height+creator.option_sep));
		bbox[3] = bbox[1]+height;
		xcenter = (bbox[0]+creator.option_sep);
		ycenter = (bbox[3]+bbox[1]) div 2;
		if(point_in_rectangle(creator.mouse_gui_x,creator.mouse_gui_y,bbox[0],bbox[1],bbox[2],bbox[3]))
		{
			creator.option_focus = index;
			if(mouse_check_button_pressed(mb_left)){
				script_execute_array(effect_script,effect_script_args);
			}
		}
		
	}
	static draw = function(){
		draw_set_color(creator.option_focus == index ? c2 : c1);
		if(index == creator.option_clicked) draw_set_color(c_yellow);
		draw_rectangle(bbox[0],bbox[1],bbox[2],bbox[3],false)
		draw_set_halign(fa_left);
		draw_set_valign(fa_middle);
		draw_set_color(c_black);
		draw_set_font(fDefault);
		draw_text(xcenter,ycenter,text);
	}
}


// initialize the buttons
var btn = undefined;
btn = new Button("Save",hex_map_save,[false]);
btn.init();
btn = new Button("Save As",hex_map_save,[true]);
btn.init();
btn = new Button("Load",hex_map_load,[""]);
btn.init();
btn = new Button("Rename",hex_map_rename,[""]);
btn.init();
btn = new Button("Delete",hex_map_delete,[""]);
btn.init();

// initialize the map options
menu_update();
update_options();




show_debug_message("saveload menu created!")