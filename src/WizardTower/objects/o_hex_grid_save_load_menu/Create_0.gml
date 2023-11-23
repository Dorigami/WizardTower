/// @description 

hex_hash_directory = working_directory + "/hexhashtables/"
mouse_gui_x = device_mouse_x_to_gui(0);
mouse_gui_y = device_mouse_y_to_gui(0);
gui_width = display_get_gui_width();
gui_height = display_get_gui_height();

btn_width = 10;
btn_height = 10;
button_focus = -1;
option_focus = -1;

button_list = ds_list_create();
option_list = ds_list_create();

Button = function(_text, _bbox, _scr) constructor{
	index = 0;
	creator = noone
	c1 = c_dkgray;
	c2 = c_white;
	text = _text;
	bbox = _bbox;
	xcenter = (_bbox[0] + _bbox[2]) div 2;
	ycenter = (_bbox[1] + _bbox[3]) div 2;
	effect_script = _scr;
	static Init = function(){
		creator = o_hex_grid_save_load_menu.id;
		index = ds_list_size(o_hex_grid.button_list);
		ds_list_add(o_hex_grid.button_list, self);
	}
	static Update = function(){
		if(point_in_rectangle(creator.mouse_gui_x,creator.mouse_gui_y,bbox[0],bbox[1],bbox[2],bbox[3]))
		{
			creator.button_focus = index;
			if(mouse_check_button_pressed(mb_left)){
				script_execute(effect_script);
			}
		}
		
	}
	static Draw = function(){
		draw_set_color(creator.button_focus == index ? c2 : c1);
		draw_rectangle(bbox[0],bbox[1],bbox[2],bbox[3],false)
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_font(fDefault);
		draw_text(xcenter,ycenter,text);
	}
}

Option = function(_text, _bbox, _scr) constructor{
	c1 = c_ltgray;
	c2 = c_white;
	text = _text;
	bbox = _bbox;
	effect_script = _scr;
}


// initialize the buttons
var btn = new Button(ds_list_size(button_list),"delete",);
btn.Init();


// initialize the map options
var arr = hex_hash_get_saved_names();
if(arr != -1){
	for(var i=0; i<array_length(arr); i++){
		//var opt = new Option()
	}
}








