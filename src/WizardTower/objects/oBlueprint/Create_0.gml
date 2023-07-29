/// @description 
/*
    var _struct = {
		xx : _xx,
		yy : _yy,
        type_string : _type_string,
        object : _object,
		size : _size,
        sprite_index : object_get_sprite(_object),
		mask_index : object_get_sprite(_object),
        faction : faction
    }
*/

cantplace = false;
rect = [x, y, x+GRID_SIZE, y+GRID_SIZE];
position_update_timer = -1;
position_update_time = 3;
for(var i=0;i<size[0];i++)
{
	node_grid = []
}
function CheckPlacement(){
	if(lock_to_grid)
	{
		return collision_rectangle(rect[0],rect[1],rect[2],rect[3],pEntity,false,true) || collision_rectangle(rect[0],rect[1],rect[2],rect[3],oBlueprint,false,true);
	} else {
		return collision_circle(x,y,collision_radius,pEntity,false,true) || collision_circle(x,y,collision_radius,oBlueprint,false,true);
	}
	//return collision_point(x+0.5*GRID_SIZE, y+0.5*GRID_SIZE, pEntity, false, false);
}

if(!object_exists(object)) instance_destroy();


