function point_on_screen(_room_coord_x, _room_coord_y){
	with(global.iCamera)
	{
		return point_in_rectangle(_room_coord_x, _room_coord_y, x-viewWidthHalf, y-viewHeightHalf, x+viewWidthHalf, y-viewHeightHalf);
	}
}