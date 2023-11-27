function array_to_ds_list(_arr, _ds_list){
	var _temp_list = ds_list_create();
	ds_list_clear(_ds_list);
	for(var i=0; i<array_length(_arr); i++){
		ds_list_add(_temp_list, _arr[i])
	}
	ds_list_copy(_ds_list,_temp_list);
	ds_list_destroy(_temp_list);
	return _ds_list;
}