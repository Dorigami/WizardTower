/// @description initialize game

/*
    add 8-directional cost values to the game grid for enemies
    add a 'path value' to the game grid.  enemy mobs will steer toward nodes with high path value
    add a method to cover areas of the game grid with fog_of_war (create oShroud object for the map editor)
    add steering behavior for enemy mobs
    create an instance layer on top of the fog_of_war layer, for a particle system object to display effects

    need tilemap 'PathInit' that can indicate spawn locations
*/

color0 = make_colour_rgb(13,43,69);
color1 = make_colour_rgb(32,60,86);
color2 = make_colour_rgb(84,78,104);
color3 = make_colour_rgb(141,105,122);
color4 = make_colour_rgb(208,129,89);
color5 = make_colour_rgb(255,170,94);
color6 = make_colour_rgb(255,212,163);
color7 = make_colour_rgb(255,236,214);

time_check = current_time;
time_check_total_step = 0;
time_check_input = 0;
time_check_entity_loop = 0;
time_check_actor_loop = 0;
time_check_misc = 0;

ability_hotkeys = ["1","2","3","4","5","6","7","8","9"];
keybinds_string = "escape - pause/unpause/cancel action\n" 
                + "F3 - toggle debug view\n"
                + "alt+Enter - toggle fullscreen\n"
                + "[ - spawn a base\n"
                + "] - spawn a ranger\n"
                + "left mouse - select entities\n"
                + "right mouse - command entities (move / attack)\n"
                + "ctrl+right mouse - A move command\n"
                + " - use ability 1 ["+ability_hotkeys[0]+"]  |  2 ["+ability_hotkeys[1]+"]  |  3 ["+ability_hotkeys[2]+"]\n"
                + "                       4 ["+ability_hotkeys[3]+"]  |  5 ["+ability_hotkeys[4]+"]  |  6 ["+ability_hotkeys[5]+"]\n"
                + "                       7 ["+ability_hotkeys[6]+"]  |  8 ["+ability_hotkeys[7]+"]  |  9 ["+ability_hotkeys[8]+"]\n"

MACROS();
DEFAULTSTATS();
STRUCTS();
ActorAI();
COMPONENTS();
RoomStartInitFunctions();
randomize();
game_set_speed(FRAME_RATE, gamespeed_fps);
InitializeDisplay(ASPECT_RATIO);

// initialize game grid
global.game_grid_xorigin = 0;
global.game_grid_yorigin = 0;
global.game_grid_width = 10;
global.game_grid_height = 10;
global.game_grid = ds_grid_create(global.game_grid_width, global.game_grid_height);
for(var i=0; i<global.game_grid_width;  i++){
for(var j=0; j<global.game_grid_height; j++){
    var _node = new Node(i,j);
    global.game_grid[# i, j] = _node;
}}
// other global variables
global.unitSelection = ds_list_create();
global.iEngine = id;
global.iHUD = instance_create_depth(0,0,UPPERTEXDEPTH-2, oHUD);
global.iCamera = instance_create_layer(0, 0, "Instances", oCamera);
global.iSelect = instance_create_layer(0, 0, "Instances", oSelect);
global.iSound = instance_create_layer(0, 0, "Instances", oSoundManager);
global.iEntityFlow = instance_create_layer(0,0,"Instances",oEntityFlow);
global.game_state = GameStates.PLAY;
global.game_state_previous = global.game_state;
global.mouse_focus = noone;
global.hud_focus = noone;
global.danger_set = ds_list_create();
global.interest_set = ds_list_create();
entity_count_max = 200;
cs_unit_vectors = array_create(CS_RESOLUTION, 0);
action = {};
mouse_action = {};
hud_action = {};
menu_stack = ds_stack_create();
blueprint_instance = noone;
killing_floor = ds_queue_create();
game_grid_heap = new NodeHeap();
game_grid_heap.Initialize(global.game_grid);
initial_player_abilities = array_create(9, undefined);
current_player_abilities = array_create(9, undefined);
zoom_delay_time = 10;
sell_price = 0;
SellPuffInit();

// fill the unit vector array with unit vectors for each context steering directions
for(var i=0; i<CS_RESOLUTION; i++){
    cs_unit_vectors[i] = speed_dir_to_vect2(1, i*(360 div CS_RESOLUTION));
}

actor_list = ds_list_create();

// add actors
player_actor = new Actor(true, PLAYER_FACTION);  // 'true' means that this actor is a player
enemy_actor = new Actor(false, ENEMY_FACTION);  // 'false' means that this actor is not a player
neutral_actor = new Actor(false, NEUTRAL_FACTION);  // 'false' means that this actor is not a player
ds_list_add(actor_list, neutral_actor, player_actor, enemy_actor);



window_set_fullscreen(false);
if(ROOM_START == rShaderTest) instance_create_depth(0,0,0,oShaderTest);
room_goto(ROOM_START);

/*
// Entity Setup as Fluid Simulation

	using the infinite grid setup from the fluid simulation, we can simplify some of the proximity checking for entities:
		- Create a spatial lookup for entity positions
		- Create a spatial lookup for entity LoS

// movement will be influcnced by 4 factors(weights)
	friendly target density (force pushing friendly units away from each other when too close)
	enemy target density (force pushing hostile units away from each other when too close)
	goal direction
	enemies in LoS

// this is going to require:
	- spatial_lookup_position
	- lookup_radius_position
	
	- spatial_lookup_los
	- lookup_radius_los

should this be controlld by the engine?

i could create a enemy controller.  would it replace the actor struct?  it doesn't need to.  i can have only work to update the spatial lookup and the entities can reference that seperately when they update

the spatial lookup will only be used for the movement, will have a more basic solutions for attack ranges (probably what is already implemented)


*/
function entity_flow_init(){
	var _struct = {
		entity_count_max : entity_count_max,
		spatial_lookup : array_create()
	}
}
