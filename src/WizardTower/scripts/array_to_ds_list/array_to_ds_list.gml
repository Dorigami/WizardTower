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
function ds_list_to_array(_ds_list)
{
	var size = ds_list_size(_ds_list);
	var arr = array_create(size, 0);
	for(var i=0;i<size;i++)
	{
		arr[i] = _ds_list[| i];
	}
	return arr;
}