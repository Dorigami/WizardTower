/// @description 

function Update(){
    
//--// do the context steering
    // get desired direction
	// weights = [goal, attack, density, discomfort]
	var _movement_weights = [1,1,1,1];
	if(!is_undefined(steering_behavior)) && (script_exists(steering_behavior)) 
	{
		//show_debug_message("steering script for object [{1}] is: {0}", script_get_name(steering_behavior), object_get_name(object_index));
		script_execute_array(steering_behavior, _movement_weights);
	}
	// steer toward desired direction

	
	// update position relative to the gui layer
	if(visible){
		gui_x = position[1] - camera_get_view_x(view_camera[0]);
		gui_y = position[2] - camera_get_view_y(view_camera[0]);
	}
	
	// animate
	var _idle_lim = 0.6;
	var _move_lim = 0.8;
	var _spd = vect_len(vel_movement);
	var _dir = vect_direction(vel_movement);
	var _attacking = false;
    var _theta = 5; // this value will determine a deadzone where the sprite cannot flip their scaling
	if(spr_idle != -1)
	{
		if(!is_undefined(fighter) && fighter.attack_index > -1){
			_attacking = true;
			var _dur = fighter.attack_index == 0 ? fighter.basic_attack.duration : fighter.active_attack.duration;
			if(sprite_index != spr_attack) 
			{
				sprite_index = spr_attack;
				image_index = 0;
				image_speed = 0;
			}
			image_index = min(image_number-1, image_index + image_number/(_dur*FRAME_RATE));

            _dir = entity_type == STRUCTURE ? 0 : attack_direction;
		} else {
            if(_spd <= _idle_lim)
            {
                if(sprite_index != spr_idle) 
                {
                    sprite_index = spr_idle;
                    image_index = 0;
                    image_speed = 1;
                }
			} else if(_spd > _move_lim){
                if(sprite_index != spr_move) 
                {
                    sprite_index = spr_move;
                    image_index = 0;
                    image_speed = 1;
                }
            }
        }
		if((vect_len(vel_movement) > 0) || (_attacking))
		{
	        if(_dir > 90+_theta) && (_dir < 270-_theta){
	            if(image_xscale != -1) image_xscale = -1;
	        } else if(_dir < 90-_theta) || (_dir > 270+_theta){
	            if(image_xscale != 1) image_xscale = 1;
	        }
		}
	}

    // update the healthbars' position
    if(visible)
    {
		depth = LOWERTEXDEPTH - 0.3*y;
        if(!is_undefined(fighter)){
            basicattackbar_bbox[0] = bbox_left;
            basicattackbar_bbox[1] = bbox_top-4*bar_height;
            basicattackbar_bbox[2] = bbox_right;
            basicattackbar_bbox[3] = bbox_top-5*bar_height;

            activeattackbar_bbox[0] = bbox_left;
            activeattackbar_bbox[1] = bbox_top-3*bar_height;
            activeattackbar_bbox[2] = bbox_right;
            activeattackbar_bbox[3] = bbox_top-4*bar_height;

            healthbar_bbox[0] = bbox_left;
            healthbar_bbox[1] = bbox_top-2*bar_height;
            healthbar_bbox[2] = bbox_right;
            healthbar_bbox[3] = bbox_top-3*bar_height;
        }
        if(!is_undefined(structure)) || (!is_undefined(blueprint)){
            buildtimer_bbox[0] = bbox_left;
            buildtimer_bbox[1] = bbox_top-bar_height;
            buildtimer_bbox[2] = bbox_right;
            buildtimer_bbox[3] = bbox_top-2*bar_height;
        }
        if(!is_undefined(ai)){
            commandtimer_bbox[0] = bbox_left;
            commandtimer_bbox[1] = bbox_top;
            commandtimer_bbox[2] = bbox_right;
            commandtimer_bbox[3] = bbox_top-bar_height;
        }
    }
}

function DistanceTo(_other_entity, _tiles=false){
	// returns distance between entities in terms of pixels
	
	var _selfpos = [position[1], position[2]];
	var _otherpos = [_other_entity.position[1], _other_entity.position[2]];
	if(size_check > 2) _selfpos = _other_entity.NearestCell(id, true);
	if(_other_entity.size_check > 2) _otherpos = id.NearestCell(_other_entity, true);
	if(!_tiles)
	{
		return point_distance(_selfpos[0], _selfpos[1], _otherpos[0], _otherpos[1]) - _other_entity.collision_radius;
	} else {
		return abs(xx-_other_entity.xx) + abs(yy-_other_entity.yy);
	}
}
function NearestCell(_other_entity, rtn_as_position=false){
    // this function assumes that the calling entity is of size 1x1 (occupies one tile)
    // and other entity can be any size (i.e. 2x3, 5x5)
    var _size = _other_entity.size;
    var _rtn = [_other_entity.xx, _other_entity.yy];
    if(_size[0]+_size[1] == 2)
    {
        // other entity occupies only one tile, do nothing here
    } else {
        // other entity is larger than one tile
        var xc = _size[0] div 2;
        var yc = _size[1] div 2;

        _rtn[0] = clamp(xx,  
                        _other_entity.xx-xc,             // western tile limit
                        _other_entity.xx+_size[0]-xc-1); // eastern tile limit
        _rtn[1] = clamp(yy, 
                        _other_entity.yy-yc,             // northern tile limit
                        _other_entity.yy+_size[1]-yc-1); // southern tile limit
    }
    if(rtn_as_position){
		// var _node = global.game_grid[# _rtn[0], _rtn[1]]
		_rtn[0] = 0;// _node.x;
		_rtn[1] = 0;// _node.y;
	}
	return _rtn;
	
}

function EntityVisibility(){
	visible = abs(position[1] - global.iCamera.x) < global.iCamera.viewWidthHalf+20 && 
	          abs(position[2] - global.iCamera.y) < global.iCamera.viewHeightHalf+20;
}

function DensitySplat(){
    // 'splat' the density values
    var _grid = global.iEngine.faction_entity_density_maps[| faction];
    var half_grid = GRID_SIZE div 2;
    var _x = position[1] - global.game_grid_bbox[0];
    var _y = position[2] - global.game_grid_bbox[1];
//--//var density_falloff = 0.9;

    // find closest cell center whose coordinates are both less than that of the person (cell is refered to as 'A')
    var Ax = _x div (half_grid); 
        if(Ax % 2 == 0) Ax -= 1;
        Ax *= half_grid;
    var Ay = _y div (half_grid); 
        if(Ay % 2 == 0) Ay -= 1;
        Ay *= half_grid;
    var Axcell = Ax div GRID_SIZE;
    var Aycell = Ay div GRID_SIZE;

    // compute offset coordinates from this grid cell
    var dx = _x - Ax;
    var dy = _y - Ay;
    // (A) density base_location
    if(point_in_rectangle(Axcell, Aycell, 0, 0, global.game_grid_width-1, global.game_grid_height-1))
    { 
		_grid[# Axcell, Aycell] += sqrt(sqr(GRID_SIZE-dx)+sqr(GRID_SIZE-dy)); 
	}
//--//{ _grid[# Axcell, Aycell] += 100+min(1-dx, 1-dy)^density_falloff; }
    // (B) density right of A
    if(point_in_rectangle(Axcell+1, Aycell, 0, 0, global.game_grid_width-1, global.game_grid_height-1))
    { 
		_grid[# Axcell+1, Aycell] += sqrt(sqr(dx)+sqr(GRID_SIZE-dy));
	}
//--//{ _grid[# Axcell+1, Aycell] += -min(1-dx, dy)^density_falloff; }
    // (C) density below A
    if(point_in_rectangle(Axcell, Aycell+1, 0, 0, global.game_grid_width-1, global.game_grid_height-1))
    { 
		_grid[# Axcell, Aycell+1] += sqrt(sqr(GRID_SIZE-dx)+sqr(dy));
	}
    // (D) density down and right of A
    if(point_in_rectangle(Axcell+1, Aycell+1, 0, 0, global.game_grid_width-1, global.game_grid_height-1))
    { 
		_grid[# Axcell+1, Aycell+1] += sqrt(sqr(dx)+sqr(dy));
	}
}

// if(spr_idle != -1) sprite_index = spr_idle;
shadow_scale = 0.5 * sprite_get_width(sprite_index) / sprite_get_width(sShadow);
var _str = object_get_name(object_index);
_str = string_lower(string_copy(_str,2,string_length(_str)-1));
type_string = _str;
faction_list_index = -1; // this index is set through the unit constructor script
selected = false;
nodes_in_range = [];

// shader stuff
upixelH = shader_get_uniform(shOutline, "pixelH");
upixelW = shader_get_uniform(shOutline, "pixelW");
texelW = texture_get_texel_width(sprite_get_texture(sSelect,0));
texelH = texture_get_texel_height(sprite_get_texture(sSelect,0));

// data bars that display over-head
gui_x = 0;
gui_y = 0;
bar_height = 6;
healthbar_bbox =       [0,0,0,0];
buildtimer_bbox =      [0,0,0,0];
commandtimer_bbox =    [0,0,0,0];
basicattackbar_bbox =  [0,0,0,0];
activeattackbar_bbox = [0,0,0,0];

