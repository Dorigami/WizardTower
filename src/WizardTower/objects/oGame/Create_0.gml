/// @description 

#macro RESOLUTION_W 320
#macro RESOLUTION_H 192
#macro ROOMSTART rStartMenu
#macro GRID_WIDTH 15
#macro GRID_HEIGHT 15
#macro CELL_WIDTH 16
#macro CELL_HEIGHT 16
#macro FRAME_RATE 60
#macro MENUDEPTH 7777
#macro OUT 0
#macro IN 1
enum PLAYERSTATE 
{
	FREE,
	MOVE,
	SPAWN,
	DEAD,
	FALL,
	STRUCK,
	TOTAL
}
enum ENEMYSTATE
{
	FREE,
	ACT,
	SPAWN,
	DEAD,
	FALL,
	TOTAL
}
enum NODE
{
    BROKEN,
	SOLID,
	SINGLESOLID,
    PSOLID,
    PBROKEN,
    TOTAL
}
// set up the camera(s)
function InitializeDisplay(){
	//// dynamic resolution
		//ideal_width_ = 0;
		//ideal_height_ = RESOLUTION_H;
		//aspect_ratio_ = display_get_width() / display_get_height();
		//ideal_width_ = round(ideal_height_*aspect_ratio_);
	// static resolution
	ideal_width_ = RESOLUTION_W;
	ideal_height_ = RESOLUTION_H;
	aspect_ratio_ = RESOLUTION_W / RESOLUTION_H;

	//// perfect pixel scaling
		//if(display_get_width() mod ideal_width_ != 0)
		//{
		//	var d = round(display_get_width() / ideal_width_);
		//	ideal_width_ = display_get_width() / d;
		//}
		//if(display_get_height() mod ideal_height_ != 0)
		//{
		//	var d = round(display_get_height() / ideal_height_);
		//	ideal_height_ = display_get_height() / d;
		//}

	//check for odd numbers
	if(ideal_width_ & 1) ideal_width_++;
	if(ideal_height_ & 1) ideal_height_++;

	//do the zoom
	zoom = 3;
	zoom_max_ = floor(display_get_width() / ideal_width_);
	zoom = min(zoom, zoom_max_)
	
	// enable & set views of each room
	for(var i=0; i<=room_last; i++)
	{
		show_debug_message(room_get_name(i)+" has been initialized")
		room_set_view_enabled(i, true);
		room_set_viewport(i,0,true,0,0,ideal_width_, ideal_height_);
	}	
	surface_resize(application_surface, RESOLUTION_W, RESOLUTION_H);
	display_set_gui_size(RESOLUTION_W, RESOLUTION_H);
	window_set_size(RESOLUTION_W*zoom, RESOLUTION_H*zoom);
	alarm[0] = 1;
}

function LoadLevel(){
	/// @description  Save the current map
	var _ds_grid = ds_grid_create(room_width div CELL_WIDTH, room_height div CELL_HEIGHT);
	mp_grid_to_ds_grid(_mp_grid, _ds_grid);
	var i, j, _str;
	var _base_x = 0;
	var _base_y = 0;
	var _w = ds_grid_width(_ds_grid);
	var _h = ds_grid_height(_ds_grid);     
	var _filename = "newMap";
	
		//key
	/*
	    - = floor cell
	    # = wall cell
	    @ = supplybase spawn spawn 
		
		save location:
		C:\Users\Dorian Payton\AppData\Local\CyberHorde
	*/
	
//--//LOAD
    _filename = get_string("LOAD - Enter the name of the the room?", "default"); if _filename = "" exit
    //read file to get row and column sizes
    var my_file = file_text_open_read(working_directory + _filename + ".txt"); if my_file = -1 exit

    //move down to text file map data (skip 3 lines)
    _str = file_text_readln(my_file);
    _str = file_text_readln(my_file);
    _str = file_text_readln(my_file);

	// remove the supplybase from the map grid
	if(instance_exists(o_supplybase))
	{
		with(o_supplybase)
		{ mp_grid_building_clear() }
	}
	
	//go to next line, then convert line text to map data
	for(i=1; i<=_h; i++)
	{   file_text_readln(my_file); //read the next line for each row
		_str = file_text_read_string(my_file);
	for(j=0; j<_w; j++)
	{
		// clear the tilemap
		tilemap_set(global.tilemap,0,j,i);
		// update the map grid
		switch(string_char_at(_str, j+1))
		{
		    case "-": //floor cell
				mp_grid_clear_cell(global.map_grid,j,i);
		        con_map.noise_grid[# j, i] = FLOOR;
		        break;
		    case "#": //wall cell
				mp_grid_add_cell(global.map_grid,j,i);
		        con_map.noise_grid[# j, i] = VOID;
		        break;
		    case "@": //player spawn  
				mp_grid_clear_cell(global.map_grid,j,i);
		        con_map.noise_grid[# j, i] = FLOOR;
				_base_x = j*CELL_WIDTH;
				_base_y = i*CELL_HEIGHT;
				if(!instance_exists(o_supplybase))
				{
					instance_create_layer(0,0,"Instances",o_supplybase);
					with(o_supplybase)
					{
						x = j*CELL_WIDTH;
						y = i*CELL_HEIGHT;
						mp_grid_building_add();
					}
				}
		        break;
		}
	}
	}
//--// retile using the new map_grid //
	var _xx, _yy
	var _hcells = 90;
	var _vcells = 90;

	// update the noise grid within the map controller in accordance with the text file
	if(instance_exists(con_map))
	{
		with(con_map)
		{
			// create the wall tiles
			for (_yy = 1; _yy < _vcells-1; _yy++) { for (_xx = 1; _xx < _hcells-1; _xx++) 
			{
					if (noise_grid[# _xx, _yy] != FLOOR) {
						_north_tile = noise_grid[# _xx, _yy-1] == VOID;
						_west_tile = noise_grid[# _xx-1, _yy] == VOID;
						_east_tile = noise_grid[# _xx+1, _yy] == VOID;
						_south_tile = noise_grid[# _xx, _yy+1] == VOID;
		
						_tile_index = NORTH*_north_tile + WEST*_west_tile + EAST*_east_tile + SOUTH*_south_tile + 1;
						if (_tile_index == 1) {
							noise_grid[# _xx, _yy] = FLOOR	
						}
					}
			}}

			for (_yy = 1; _yy < _vcells-1; _yy++) { for (_xx = 1; _xx < _hcells-1; _xx++) 
			{
					if (noise_grid[# _xx, _yy] != FLOOR) {
						var _north_tile = noise_grid[# _xx, _yy-1] == VOID;
						var _west_tile = noise_grid[# _xx-1, _yy] == VOID;
						var _east_tile = noise_grid[# _xx+1, _yy] == VOID;
						var _south_tile = noise_grid[# _xx, _yy+1] == VOID;
		
						var _tile_index = NORTH*_north_tile + WEST*_west_tile + EAST*_east_tile + SOUTH*_south_tile + 1;
						tilemap_set(global.tilemap, _tile_index, _xx, _yy);
					}
			}}
		}
	}
	
	// move and set the base after retiling is finished
	if(instance_exists(o_supplybase))
	{
		with(o_supplybase)
		{
			x = _base_x;
			y = _base_y;
			mp_grid_building_add();
		}
	}
}
function SaveLevel(){
	/// @description  Save the current map
	var _ds_grid = ds_grid_create(room_width div CELL_WIDTH, room_height div CELL_HEIGHT);
	// remove the base from the map_grid
	if(instance_exists(o_supplybase))
	{
		with(o_supplybase) { mp_grid_building_clear() }
	}
	// create a ds grid from the current map grid
	mp_grid_to_ds_grid(_mp_grid, _ds_grid);
	// replace the base on the map_grid
	if(instance_exists(o_supplybase))
	{
		with(o_supplybase) { mp_grid_building_add() }
	}
	var i, j, _str;
	var _w = ds_grid_width(_ds_grid);
	var _h = ds_grid_height(_ds_grid);     
	var _filename = "newMap";

	//key
	/*
	    - = floor cell
	    # = wall cell
	    @ = supplybase spawn spawn 
		
		save location:
		C:\Users\Dorian Payton\AppData\Local\CyberHorde
	*/


//--//SAVE
	_filename = get_string("SAVE - What will you name the room?", "newMap"); if _filename = "" exit
	var my_file = file_text_open_write(working_directory + _filename + ".txt"); if my_file = -1 exit
	//write the size of cell grid to the text file
	file_text_write_string(my_file, "height:=" + string(_h));
	file_text_writeln(my_file);
	file_text_write_string(my_file, "width:=" + string(_w));
	file_text_writeln(my_file);
	
	//loop through cell grid, converting it to text file
	for(i=0; i<_h; i++)
	{   file_text_writeln(my_file); //write new line for each row
	for(j=0; j<_w; j++)
	{
	    //set cells
	    if(_ds_grid[# j, i] == 0) _str = "-"; 
	    if(_ds_grid[# j, i] == -1) _str = "#";   
	    //set location of supply base
	    if(instance_exists(o_supplybase))
	    {
			with(o_supplybase)
			{
				if(i == y div CELL_HEIGHT)
				{
					if(j == x div CELL_WIDTH)
					{
						_str = "@";
					}
				}
			}
	    }
	    //write the text
	    file_text_write_string(my_file, _str)    
	}
	} 
	file_text_close(my_file);
}

// game setup
global.playerControl = noone;
global.playerMoveCounter = 0;
moveCountCheck = global.playerMoveCounter;
global.gamePaused = false;
global.playerScore = 0;
global.playerCollected = 0;
global.currentLevel = 0;
global.nextLevel = 1;
global.muteMusic = false;
global.muteSound = false;
global.iCamera = instance_create_layer(0,0,"Instances",oCamera);
global.iParticles = instance_create_layer(0,0,"Instances",oParticles);
game_set_speed(FRAME_RATE, gamespeed_fps);
InitializeDisplay();

{ // grid setup
	function GridNode(_x=0,_y=0) constructor
	{
	    cell = vect2(_x,_y); // grid position
	    center = vect2(_x*CELL_WIDTH+0.5*CELL_WIDTH, _y*CELL_HEIGHT+0.5*CELL_HEIGHT); // room position (centered on the cell)
	    state = NODE.SOLID;
	    enabled = false;
	    timer = -1;
	    refreshTime = 4;
	    fallTime = 2;
		static SetTile = function()
		{
			switch(state)
			{
				case NODE.SOLID:
					tilemap_set(layer_tilemap_get_id(layer_get_id("DungeonBot")),69,cell[1],cell[2]);
					break;
				case NODE.SINGLESOLID:
					tilemap_set(layer_tilemap_get_id(layer_get_id("DungeonBot")),113,cell[1],cell[2]);
					break;
				case NODE.PSOLID:
					tilemap_set(layer_tilemap_get_id(layer_get_id("DungeonBot")),149,cell[1],cell[2]);
					break;
				case NODE.BROKEN:
					tilemap_set(layer_tilemap_get_id(layer_get_id("DungeonBot")),134,cell[1],cell[2]);
					break;
				case NODE.PBROKEN:
					tilemap_set(layer_tilemap_get_id(layer_get_id("DungeonBot")),134,cell[1],cell[2]);
					break;
			}
		}
	}
	global.gridSpace = ds_grid_create(GRID_WIDTH, GRID_HEIGHT);
	global.startPoint = vect2(0,0);
	global.goalPoint = vect2(0,0);
	for(var i=0;i<GRID_WIDTH;i++)
	{
	for(var j=0;j<GRID_HEIGHT;j++)
	{
		global.gridSpace[# i, j] = new GridNode(i,j);
	}
	}
	// create a list for keeping track of timers that are currently running for each node
	nodeActiveTimers = ds_list_create();
}

room_goto(ROOMSTART);