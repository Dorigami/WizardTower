function nine_slice_box_smooth(_sprite,_x1,_y1,_x2,_y2)
{
	// init variables
	var _size = sprite_get_width(_sprite) / 3;
	
	// limit minimum dimensions
	var _limit = _size*3
	if(_x2-_x1 < _limit) _x2 = _x1+_limit;
	if(_y2-_y1 < _limit) _y2 = _y1+_limit;
	
	// set width & height
	var _w = _x2 - _x1;
	var _h = _y2 - _y1;
	
//--//MIDDLE
	draw_sprite_part_ext(_sprite,0,_size,_size,1,1,_x1+_size, _y1+_size, _w-(_size*2), _h-(_size*2), c_white, image_alpha);
	
//--//CORNERS
	//top left
	draw_sprite_part(_sprite,0,0,0,_size,_size,_x1,_y1);
	//bottom left
	draw_sprite_part(_sprite,0,0,_size*2,_size,_size,_x1,_y1+_h-_size);
	//top right
	draw_sprite_part(_sprite, 0, _size*2, 0, _size, _size, _x1+_w-_size, _y1);
	//bottom right
	draw_sprite_part(_sprite,0,_size*2,_size*2,_size,_size,_x1+_w-_size, _y1+_h-_size);

//--//EDGES
	//left edge
	draw_sprite_part_ext(_sprite, 0, 0, _size, _size, 1, _x1, _y1+_size, 1, _h-(_size*2), c_white, image_alpha);
	//right edge
	draw_sprite_part_ext(_sprite, 0, _size*2, _size, _size, 1, _x1+_w-_size, _y1+_size, 1, _h-(_size*2), c_white, image_alpha);
	//top edge
	draw_sprite_part_ext(_sprite, 0, _size, 0, 1, _size, _x1+_size, _y1, _w-(_size*2), 1, c_white, image_alpha);
	//bottom edge
	draw_sprite_part_ext(_sprite, 0, _size, _size*2, 1, _size, _x1+_size, _y1+_h-(_size), _w-(_size*2), 1, c_white, image_alpha);

}