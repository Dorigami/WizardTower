function BuilderCreate(_type_string, _faction){
	with(global.iEngine)
	{
		var _actor = actor_list[| _faction];
		var _stats = _actor.fighter_stats[$ _type_string];
		// remove existing blueprint
		if(instance_exists(blueprint_instance)) 
		{
			instance_destroy(blueprint_instance);
			blueprint_instance = noone;
		}
		// if the type is of a structure, then set flag to lock its position to the map grid
		// this flag will also help set the array of possible entities to build during the build state
		//if(_is_unit){
		//	var _type_arr = ["shieldbearer", "spearbearer", "lensbearer", "torchbearer"];
		//	var _gridlock = false;
		//} else {
			var _type_arr = ["turret","barricade"];
			var _gridlock = true;
		//}
		// change state
		global.game_state_previous = global.game_state;
		global.game_state = GameStates.BUILDING;
		if(global.game_state_previous == GameStates.BUILDING) global.game_state_previous = GameStates.PLAY;
		
		// initialize state
		var _xx = mouse_x div GRID_SIZE; _xx = clamp(_xx,0,global.game_grid_width-1);
		var _yy = mouse_y div GRID_SIZE; _yy = clamp(_yy,0,global.game_grid_height-1);
		show_debug_message("creating blueprint, type string is {0}", _type_string)
		var _struct = {
			lock_to_grid : _gridlock,
			xx : _xx,
			yy : _yy,
			type_string : _type_string,
			object : _stats.obj,
			size : _stats.size,
			collision_radius : round(0.6*GRID_SIZE),
			sprite_index : object_get_sprite(_stats.obj),
			mask_index : object_get_sprite(_stats.obj),
			faction : _faction,
			type_arr : _type_arr}
		blueprint_instance = instance_create_layer(_xx*GRID_SIZE, _yy*GRID_SIZE, "Instances", oBlueprint, _struct);
		show_debug_message("blueprint's type string is: {0}", blueprint_instance.type_string)
	}
} 

function BuilderCreateBase(_faction){ BuilderCreate("base", _faction) }
function BuilderCreateBarracks(_faction){ BuilderCreate("barracks", _faction) }
function BuilderCreateTurret(_faction){ BuilderCreate("turret", _faction) }
function BuilderCreateBarricade(_faction){ BuilderCreate("barricade", _faction) }

function BuildStateUnit(){ BuilderCreate("shieldbearer", true) }
function BuildStateStructure(){ BuilderCreate("conduit", false) }

// light beam (basic)
// spread firelight (active)
// unit (toggle though units once targeting begins)
// lamp (sc2 pylon)
// barricade  (sc2 force field)
// 