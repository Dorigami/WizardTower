function EnforceTileCollision(){
	if(!point_in_rectangle(xx, yy, 0, 0, global.game_grid_width-1, global.game_grid_height-1)) exit;
	var _node = global.game_grid[# xx, yy];
	if(!_node.walkable) || (_node.blocked)
	{
		var dx = position[1] - _node.x;
		var dy = position[2] - _node.y;
		
		if(dx < dy)
		{
			// shift x position to node boundary
			position[1] = _node.x + sign(dx)*HALF_GRID;
			if(sign(velocity[1]) == sign(dx)) velocity[1] = 0;
		} else {
			// shift y position to node boundary
			position[2] = _node.y + sign(dy)*HALF_GRID;
			if(sign(velocity[2]) == sign(dy)) velocity[2] = 0;
		}
	}
}