/// @description 

for(var i=0;i<GRID_WIDTH;i++)
{
for(var j=0;j<GRID_HEIGHT;j++)
{
    var _node = global.gridSpace[# i, j];
    if(!_node.walkable) 
	{
		draw_set_alpha(0.7);
		draw_set_color(c_yellow);
	} else {
		draw_set_alpha(0.1);
		draw_set_color(c_white);
	}
	
    draw_rectangle(i*CELL_SIZE, j*CELL_SIZE, i*CELL_SIZE + CELL_SIZE-1, j*CELL_SIZE + CELL_SIZE-1, true);

    //draw_set_font(fText);
    //draw_set_alpha(1);
    //// east density
    //draw_set_halign(fa_right);
    //draw_set_valign(fa_middle);
    //draw_text(_node.center[1]+0.45*CELL_SIZE, _node.center[2], string(_node.density[EAST]));
    //// north density
    //draw_set_halign(fa_center);
    //draw_set_valign(fa_top);
    //draw_text(_node.center[1], _node.center[2]-0.45*CELL_SIZE, string(_node.density[NORTH]));
    //// west density
    //draw_set_halign(fa_left);
    //draw_set_valign(fa_middle);
    //draw_text(_node.center[1]-0.45*CELL_SIZE, _node.center[2], string(_node.density[WEST]));
    //// south density
    //draw_set_halign(fa_center);
    //draw_set_valign(fa_bottom);
    //draw_text(_node.center[1], _node.center[2]+0.45*CELL_SIZE, string(_node.density[SOUTH]));
	//// cell
	//draw_set_halign(fa_center);
    //draw_set_valign(fa_middle);
    //draw_text(_node.center[1], _node.center[2], "["+string(_node.cell[1])+" "+string(_node.cell[2])+"]");
}
}