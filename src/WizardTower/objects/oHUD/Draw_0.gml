/// @description 
if(minimap_needed) generate_minimap_sprite();

with(global.iEngine)
{
	if(other.show_selected_entities > 0)
	{
		for(var i=0;i<other.show_selected_entities;i++){
			var _ent = player_actor.selected_entities[| i];
			if(!is_undefined(_ent)) && (instance_exists(_ent)) && (_ent.visible)
			{
				// show structure rally point
				if(_ent.entity_type == STRUCTURE)
				{
					draw_set_alpha(1);
					draw_set_color(c_blue);
					draw_circle(_ent.structure.rally_x,_ent.structure.rally_y,4,false);
				}
				// put arrow above a selected entity
				//draw_sprite(sSelectionIndicator, 0, _ent.gui_x, _ent.gui_y-0.6*sprite_height);
			}
		}
	}
}






