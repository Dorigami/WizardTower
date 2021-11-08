/// @description Level Setup on playspace

// setup view
with(global.iCamera)
{
	camera_set_view_size(view_camera[0], RESOLUTION_W, RESOLUTION_H);
	xTo = round(0.5*room_width);
	yTo = round(0.5*room_height);
	x = xTo;
	y = yTo;
}
// init level
if(string_last_pos_ext("Level", room_get_name(room), string_length(room_get_name(room))) != 0)
{
	// reset collectables count
	global.playerCollected = 0;
	// play space setup
	var _playTiles = layer_tilemap_get_id(layer_get_id("PlayTiles"));
	var _width = room_width div CELL_WIDTH;
	var _height = room_height div CELL_HEIGHT;
	ds_grid_resize(global.gridSpace , _width, _height);
	for(var i=0;i<_width;i++)
	{
	for(var j=0;j<_height;j++)
	{
	    // give fresh nodes to the grid space
	    delete global.gridSpace[# i, j];
	    var _node = new GridNode(i,j);
	    global.gridSpace[# i, j] = _node;
		_node.timer = -1;
	    // block the node if it's not part of the play area
		var _tileType = tilemap_get_at_pixel(_playTiles,_node.center[1],_node.center[2])
	    if(_tileType > 0)
		{
			_node.enabled = true;
			_node.state = _tileType;
			_node.SetTile();
		}
	}
	}
	with(oSpawnPoint)
	{
		if(!instance_exists(oPlayer))
		{
			instance_create_layer(x+8,y+8,"Instances",oPlayer);
		}
	}
	with(oCollectable)
	{
		with(oGoalPoint)
		{
			pointsRequired++;
		}
	}
	with(oSpawnPointEnemy1)
	{
		instance_create_layer(x+8,y+8,"Instances", oEnemy1)
		instance_destroy();
	}
}