function ability_scheme_set(
	// these are the default types for the ability hotbar
	_ability_array=["barricade","kinetic tower","magic tower",
	                "health_up","money_up","supply_up",
					"","toggle_info","sell_towers"]
	){
	// clear the existing set of abilities, then insert the new ones from the '_ability array'
	with(global.iEngine){
		array_delete(current_player_abilities,0,9);
		for(var i=0; i<9; i++){
			// create the ability instance
			current_player_abilities[i] = new Ability(_ability_array[i]);
			
			// update the action buttons based on the the new ability
			var _btn = global.iHUD.abilities_buttons[i];
			if(current_player_abilities[i].name == "null") 
			{
				text_window_enabled = false;
				enabled = false;
			} else {
				text_window_enabled = true;
				enabled = true;
			}
		}
	}
}
