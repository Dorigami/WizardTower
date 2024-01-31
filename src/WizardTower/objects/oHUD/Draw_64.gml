/// @description 
draw_set_font(fDefault)

draw_sprite_ext(sMainGameHUD, 0, 0, 0, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

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
with(global.iEngine)
{
	if(other.show_selected_entities > 0)
	{
		for(var i=0;i<other.show_selected_entities;i++){
			var _ent = player_actor.selected_entities[| i];
			if(!is_undefined(_ent)) && (instance_exists(_ent)) && (_ent.visible)
			{
				// put arrow above a selected entity
				draw_sprite(sSelectionIndicator, 0, _ent.gui_x, _ent.gui_y-0.6*sprite_height);
			}
		}
	}
}
if(global.game_state == GameStates.SELLING)
{
	draw_set_halign(fa_middle);
	draw_text(0.5*display_get_gui_width(),0.5*display_get_gui_height(),"press confirm [E] to sell all seslected structures\nSell Value: $"+string(global.iEngine.sell_price));
}

