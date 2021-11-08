/// @description 

// remove from selection
var _index = ds_list_find_index(global.unitSelection,id);
if(selected) && (_index != -1)
{
	ds_list_delete(global.unitSelection, _index);
}
