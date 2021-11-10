function EmptySelection(){
	for(var i=0;i< ds_list_size(global.unitSelection);i++)
	{
		global.unitSelection[| i].selected = false;
	}
	ds_list_clear(global.unitSelection);
}