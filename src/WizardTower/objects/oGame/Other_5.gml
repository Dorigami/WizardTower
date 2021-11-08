/// @description stop node timers

if(string_last_pos_ext("Level", room_get_name(room), string_length(room_get_name(room))) != 0)
{
	// play space setup
	var _width = room_width div CELL_WIDTH;
	var _height = room_height div CELL_HEIGHT;
	for(var i=0;i<_width;i++)
	{
	for(var j=0;j<_height;j++)
	{
	    // give fresh nodes to the grid space
	    var _node = global.gridSpace[# i, j];
		if(!is_undefined(_node)) _node.timer = -1;
	}
	}
}