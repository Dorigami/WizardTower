/// @description 

// target needs to be an instance id of the object controlling enemy spawn.
// based on current workflow, the object_index to look for would be oEnemyLevelData 
// which exists as part of the room when it's created
target = noone;
target_check = undefined;
target_level_type = undefined;
target_level_content = undefined; // target data is what this inspector needs in order to draw to the screen
step_script = -1;
draw_script = -1;

// get a target if one exists
with(oEnemyLevelData)
{
	other.target = id;
}
//**// private functions:

function Init(_new_target){
	target_level_type = target.level_type;
	target_level_content = target.level_content;
	switch(target_level_type)
	{
		case "wave_defense":
			var _sep = round(4+sprite_get_width(sLevelProgressWaveIndicator));	 
			var _names = struct_get_names(target_level_content);
			wave_count = array_length(_names); 
			wave_index = -1;
			wave_indicators_positions = array_create(wave_count,0);
			wave_indicators_image_indexes = array_create(wave_count,0);
			wave_indicators_alpha = 0;
			// initial positions for the indicators
			middle_length_goal = 20 + (_sep*wave_count)
			var _center_x = x - (middle_length_goal div 2);
			var _center_y = sprite_height div 2;
			var _ox = _center_x - (wave_count div 2)*_sep - (wave_count%2)*0.5*_sep;
			var _oy = _center_y+5;
			for(var i=0;i<wave_count;i++)
			{
				wave_indicators_positions[i] = vect2(_ox+(_sep*i), _oy);
				show_debug_message("index = {0}  position = {1}", i, wave_indicators_positions[i]);
				wave_indicators_image_indexes[i] = 0;
			}
			// set scripts to handle level data updates and drawing
			step_script = wave_defense_step;
			draw_script = wave_defense_draw;
			break;
		default:
			break;
	}
	show_debug_message("oLevelProgressInspector running Init() function");
}

function wave_defense_step(){
	// control alpha of the indicator sprites
	if(wave_indicators_alpha < 1)
	{
		// alpha increases as the width of sLevelProgess stretches to its goal length
		if(middle_length/middle_length_goal > 0.9){
			wave_indicators_alpha += 0.03;
			show_debug_message("alpha = {0}", wave_indicators_alpha);
		}
	}
	// update the image indexes for the wave indicator sprites
	if(target.wave_index != wave_index)
	{
		wave_index = target.wave_index;
		// for each wave, set index for either, normal, complete or in-progress
		for(var i=0; i<wave_count; i++)
		{
			if(i < wave_index)
			{
				wave_indicators_image_indexes[i] = 2;
			} else {
				wave_indicators_image_indexes[i] = i == wave_index ? 1 : 0;
			}
		}
	}
}
function wave_defense_draw(){
	// draw title label for the inspector
	draw_set_valign(fa_top);
	draw_set_halign(fa_right);
	draw_set_alpha(image_alpha);
	draw_text(x,y,"LEVEL PROGRESS: ");
	// draw wave indicators
	for(var i=0;i<wave_count;i++)
	{
		draw_sprite_ext(
			sLevelProgressWaveIndicator, 
			wave_indicators_image_indexes[i], 
			wave_indicators_positions[i][1], 
			wave_indicators_positions[i][2],
			1,1,0,c_white,
			wave_indicators_alpha);
	}
}







