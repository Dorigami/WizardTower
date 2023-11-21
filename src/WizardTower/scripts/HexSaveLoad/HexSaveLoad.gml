function menu_hash_table_add(){
	show_debug_message("");
}
function menu_hash_table_rename(){
	show_debug_message();
}
function menu_hash_table_delete(){
	show_debug_message("delete indicated hash table");
}

function hex_hash_save(_name, _data){
	// _name is the file name where the hash table is stored
	with(o_hex_grid_save_load_menu)
	{
		var _filepath = working_directory + "/hexhashtables/" + _name;
		var json_string = json_stringify(_data);
		var _file = file_text_open_write(_filepath);
		file_text_write_string(_file, json_string);
		file_text_close(_file);
		show_debug_message("save successful");
	}
}

function hex_hash_load(_name){
	var _filepath =  + _name;
	var json_struct = undefined;
	var _file = undefined;
	if(file_exists(_filepath))
	{
		_file = file_text_open_read(_filepath);
		json_struct = json_parse(file_text_read_string(_file));
		file_text_close(_file)
		show_debug_message("Hex hash table, load successful");
	} else {
		show_debug_message("Error: cannot load Hex hash table, file doesn't exist");
	}
}

function hex_hash_get_saved_names(){
	with(o_hex_grid_save_load_menu)
	{
		var i = -1;
		var arr = [];
		var _filename = file_find_first(hex_hash_directory+"*.hsh", fa_directory);
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
