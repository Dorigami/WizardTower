/// @description 

if(enable_minimap)
{
	draw_minimap();
}
if(enable_abilities)
{
	draw_abilities();
}
if(enable_player_data)
{
	draw_player_data();
}
if(show_wave_data)
{
	draw_wave_data();
}
with(global.iEngine)
{
	if(other.show_selected_entities > 0)
	{
		for(var i=0;i<other.show_selected_entities;i++){
			var _ent = player_actor.selected_entities[| i];
			if(!is_undefined(_ent)) && (_ent.visible)
			{
				// put arrow above a selected entity
				draw_sprite(sSelectionIndicator, 0, _ent.gui_x, _ent.gui_y-0.6*sprite_height);
			}
		}
	}
}
