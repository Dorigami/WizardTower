function hex_map_save(_save_as=false){
with(o_hex_grid_save_load_menu)
{
	var _filename = global.i_hex_grid.hexmap_loaded_filename;
	if(_save_as) || (_filename == "")
	{
		_filename = get_string("enter the name to save as (file extenstion not necessary)\nLeave empty to cancel", "Level0");
	}
	if(_filename == "") exit;
	if(global.i_hex_grid.hexmap_loaded_filename != _filename) global.i_hex_grid.hexmap_loaded_filename = _filename
	if(string_pos(".map",_filename) > 0) _filename = string_copy(_filename,1,string_length(_filename)-4);
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
			ds_list_write(array_to_ds_list(hexarr_positions, _temp_list))
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
	with(o_hex_grid_save_load_menu)
	{
		update_options();
	}
	show_debug_message("Saved Hex Map [{0}]",_filename);
}
}

function hex_map_load(_filename){
	show_debug_message("Loaded Hex Map [{0}]",_filename);
}

function hex_map_delete(_filename){
	show_debug_message("Deleted Hex Map [{0}]",_filename);
}
function hex_map_rename(_filename){
	show_debug_message("Can't quite rename at this point: [{0}]",_filename);
}
function hex_map_get_saved_names(){
	with(o_hex_grid_save_load_menu)
	{
		var i = -1;
		var arr = [];
		var _filename = file_find_first(hexmap_directory+"*.map", fa_directory);
		while(_filename != "")
		{
			arr[++i] = _filename;
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
