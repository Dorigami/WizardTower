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

