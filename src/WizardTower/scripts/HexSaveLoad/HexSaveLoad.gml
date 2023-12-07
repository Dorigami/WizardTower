function hex_map_save(_save_as=false){
with(o_hex_grid_save_load_menu)
{
	var _filename = global.i_hex_grid.hexmap_loaded_filename;
	if(_save_as) || (_filename == "")
	{
		_filename = get_string("Enter the name to save as (file extenstion not necessary)\nLeave empty to cancel", "Level0");
	}
	if(_filename == "") exit;
	if(string_pos(".map",_filename) > 0) _filename = string_copy(_filename,1,string_length(_filename)-4);
	if(global.i_hex_grid.hexmap_loaded_filename != _filename) global.i_hex_grid.hexmap_loaded_filename = _filename;
	var _file = file_text_open_write(hexmap_directory + _filename + ".map");
	
	// create a ds list of all strings to be written to the file
	var _string_list = ds_list_create();
	var _temp_list = ds_list_create();
	with(global.i_hex_grid)
	{
		// write map data into a struct, then write it to the file
		var _struct = {
			hex_type : hex_type,
			hex_size : hex_size,
			offset_type : offset_type,
			h_spacing : h_spacing,
			v_spacing : v_spacing,
			hexgrid_width_max : hexgrid_width_max,
			hexgrid_height_max : hexgrid_height_max,
			hexgrid_width_pixels : hexgrid_width_pixels,
			hexgrid_height_pixels : hexgrid_height_pixels,
		}
		// write data structures into the file
		ds_list_add(_string_list,
			// struct data
			json_stringify(_struct),
			// save hexmap
			ds_map_write(hexmap),
			// save all ds lists
			ds_list_write(hexgrid_enabled_list),
			ds_list_write(hexgrid_spawn_list),
			ds_list_write(hexgrid_goal_list),
			// save all hex arrays
			ds_list_write(array_to_ds_list(hexarr_is_spawn, _temp_list)),
			ds_list_write(array_to_ds_list(hexarr_is_goal, _temp_list)),
			ds_list_write(array_to_ds_list(hexarr_enabled, _temp_list)),
			ds_list_write(array_to_ds_list(hexarr_positions, _temp_list)),
			ds_list_write(array_to_ds_list(hexarr_hexes, _temp_list)),
			ds_list_write(array_to_ds_list(hexarr_neighbors, _temp_list)),
			ds_list_write(array_to_ds_list(hexarr_containers, _temp_list)),
		);
	}
	// write strings to the file
	while(ds_list_size(_string_list) > 0)
	{
		file_text_write_string(_file, _string_list[| 0]);
		ds_list_delete(_string_list, 0);
		file_text_writeln(_file);
	}
	
	// close the file
	ds_list_destroy(_string_list);
	file_text_close(_file);
	
	// update the save/load menu if open
	update_options();
	
	show_debug_message("Saved Hex Map [ {0} ]",_filename);
}
}

function hex_map_load(_var_filename=""){
with(o_hex_grid_save_load_menu)
{
	if(_var_filename != ""){
		// use pre-determined filename to load a map
		if(string_pos(".map",_var_filename) > 0) _var_filename = string_copy(_var_filename,1,string_length(_var_filename)-4);
		if(file_exists(hexmap_directory + _var_filename + ".map"))
		{
			var _filename = _var_filename;
		} else { show_debug_message("ERROR: cannot load hexmap file, doesn't exist [{0}]",_var_filename); exit; }
	} else {
		// use the selected menu item to load a map
		if(option_clicked < 0){ show_message("You must select a file to load."); exit; }
	
		var _filename = option_list[| option_clicked].text;
		if(_filename == "") || (option_clicked == -1) exit;
		if(string_pos(".map",_filename) > 0) _filename = string_copy(_filename,1,string_length(_filename)-4);
	}
	if(global.i_hex_grid.hexmap_loaded_filename != _filename) global.i_hex_grid.hexmap_loaded_filename = _filename;
	var _temp_list = ds_list_create();
	var _struct = undefined;
	var _file = file_text_open_read(hexmap_directory + _filename + ".map");
	
	
	with(global.i_hex_grid)
	{
		// get general variables
		_struct = json_parse(file_text_readln(_file));
		hex_type = _struct.hex_type;
		hex_size = _struct.hex_size;
		offset_type = _struct.offset_type;
		h_spacing = _struct.h_spacing;
		v_spacing = _struct.v_spacing;
		hexgrid_width_max = _struct.hexgrid_width_max;
		hexgrid_height_max = _struct.hexgrid_height_max;
		hexgrid_width_pixels = _struct.hexgrid_width_pixels;
		hexgrid_height_pixels = _struct.hexgrid_height_pixels;
		// get the ds_map of the hex grid
		ds_map_read(hexmap, file_text_readln(_file))
		// get the ds_lists
		ds_list_read(hexgrid_enabled_list, file_text_readln(_file));
		ds_list_read(hexgrid_spawn_list, file_text_readln(_file));
		ds_list_read(hexgrid_goal_list, file_text_readln(_file));
		// set array data
		ds_list_read(_temp_list, file_text_readln(_file)); hexarr_is_spawn = ds_list_to_array(_temp_list);
		ds_list_read(_temp_list, file_text_readln(_file)); hexarr_is_goal = ds_list_to_array(_temp_list);
		ds_list_read(_temp_list, file_text_readln(_file)); hexarr_enabled = ds_list_to_array(_temp_list);
		ds_list_read(_temp_list, file_text_readln(_file)); hexarr_positions = ds_list_to_array(_temp_list);
		ds_list_read(_temp_list, file_text_readln(_file)); hexarr_hexes = ds_list_to_array(_temp_list);
		ds_list_read(_temp_list, file_text_readln(_file)); hexarr_neighbors = ds_list_to_array(_temp_list);
		ds_list_read(_temp_list, file_text_readln(_file)); hexarr_containers = ds_list_to_array(_temp_list);
		// update bounds for camera based on the new map
		with(global.iCamera){
			xTo = other.origin[1];
			yTo = other.origin[2];
			x = xTo;
			y = yTo;
			cam_bounds[0] = other.x - (other.h_spacing div 2);
			cam_bounds[1] = other.y - (other.v_spacing div 2);
			cam_bounds[2] = other.x + other.hexgrid_width_pixels;
			cam_bounds[3] = other.y + other.hexgrid_height_pixels - (other.v_spacing div 2);
		}
	} 
	ds_list_destroy(_temp_list);
	delete _struct;
	file_text_close(_file);
	
	show_debug_message("Loaded Hex Map [ {0} ]",_filename);
}
}

function hex_map_delete(){
with(o_hex_grid_save_load_menu)
{
	var _filename = option_list[| option_clicked].text;
	if(_filename == "") || (option_clicked == -1) exit;
	if(string_pos(".map",_filename) > 0) _filename = string_copy(_filename,1,string_length(_filename)-4);
	
	file_delete(hexmap_directory + _filename + ".map");
	
	// update the save/load menu if open
	update_options();
	
	show_debug_message("Deleted Hex Map [ {0} ]",_filename);
}
}
function hex_map_rename(){
with(o_hex_grid_save_load_menu)
{
	if(is_undefined(option_list[| option_clicked]))
	{
		show_message("you must select a file first");
		exit;
	} else {
		var _currentname = option_list[| option_clicked].text;
		var _loadedname = global.i_hex_grid.hexmap_loaded_filename;
		var _filename = get_string("Current file Selected is: " + _currentname + "\nEnter a replacement name in the field below (file extenstion not necessary)\nLeave empty to cancel", "");
	}
	if(_filename == "") exit;
	if(string_pos(".map",_filename) > 0) _filename = string_copy(_filename,1,string_length(_filename)-4);
	if(_currentname == _loadedname){ global.i_hex_grid.hexmap_loaded_filename = _filename }
	file_rename(hexmap_directory + _currentname + ".map",hexmap_directory + _filename + ".map");
	option_list[| option_clicked].text = _filename;
	show_debug_message("Rename Complete: [ {0} ] to [ {1} ]", _currentname, _filename);
}
}
function hex_map_get_saved_names(){
	with(o_hex_grid_save_load_menu)
	{
		var i = -1;
		var arr = [];
		var _filename = file_find_first(hexmap_directory+"*.map", fa_directory);
		while(_filename != "")
		{
			arr[++i] = string_copy(_filename,1,string_length(_filename)-4);
			_filename = file_find_next();
		}
		file_find_close();
		show_debug_message("hex_hash_get_saved_names: count = {0}", i);
		return i == -1 ? i : arr;
	}
}
function hex_map_saveload_menu_click_option(index){
	with(o_hex_grid_save_load_menu)
	{
		option_clicked = index;
	}
	show_debug_message("option {0} clicked",index);
}
