function EnforceTileCollision(_is_flyer=false){
	if(!point_in_rectangle(xx, yy, 0, 0, global.game_grid_width-1, global.game_grid_height-1)) exit;
	var _node = global.game_grid[# xx, yy];
	if(!_is_flyer){
		// grounded entity collision
		if(!_node.walkable) || (_node.blocked)
		{
			show_debug_message("Tile collision occured at {0}, {1}", xx, yy);
			var dx = position[1] - _node.x;
			var dy = position[2] - _node.y;
		
			if(abs(dx) < abs(dy))
			{
				// shift x position to node boundary
				position[1] = _node.x + sign(dx)*(HALF_GRID-1);
				if(sign(vel_movement[1]) != sign(dx)) vel_movement[1] = 0;
				if(sign(vel_force[1]) != sign(dx)) vel_force[1] = 0;
			} else {
				// shift y position to node boundary
				position[2] = _node.y + sign(dy)*(HALF_GRID-1);
				if(sign(vel_movement[2]) != sign(dy)) vel_movement[2] = 0;
				if(sign(vel_force[2]) != sign(dy)) vel_force[2] = 0;
			}
		}
	} else {
		// flying entity collision
		if(_node.blocked)
		{
			show_debug_message("Tile collision occured at {0}, {1}", xx, yy);
			var dx = position[1] - _node.x;
			var dy = position[2] - _node.y;
		
			if(abs(dx) < abs(dy))
			{
				// shift x position to node boundary
				position[1] = _node.x + sign(dx)*(HALF_GRID-1);
				if(sign(vel_movement[1]) != sign(dx)) vel_movement[1] = 0;
				if(sign(vel_force[1]) != sign(dx)) vel_force[1] = 0;
			} else {
				// shift y position to node boundary
				position[2] = _node.y + sign(dy)*(HALF_GRID-1);
				if(sign(vel_movement[2]) != sign(dy)) vel_movement[2] = 0;
				if(sign(vel_force[2]) != sign(dy)) vel_force[2] = 0;
			}
		}
	}
}
