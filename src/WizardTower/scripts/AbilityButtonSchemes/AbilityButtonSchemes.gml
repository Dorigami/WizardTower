function ability_scheme_set_default(){
	with(global.iEngine)
	{
		var _type = "";
		// clear the current abilities
		array_delete(current_player_abilities,0,9);
		// get new abilities
		for(var i=0;i<9;i++)
		{
			switch(i)
			{
			case 0: _type = "barricade"; break; 
			case 1: _type = "gunturret"; break; 
			case 2: _type = "sniperturret"; break; 
			case 3: _type = "health_up"; break; 
			case 4: _type = "money_up"; break; 
			case 5: _type = "supply_up"; break; 
			case 6: _type = ""; break; 
			case 7: _type = "toggle_info"; break; 
			case 8: _type = "sell_towers"; break; 
			}
			// create abilites and add them to initial and stored ability arrays
			current_player_abilities[i] = new Ability(_type);
		}
	}
}
function ability_scheme_set_barricade(){
	with(global.iEngine)
	{
		var _type = "";
		// clear the current abilities
		array_delete(current_player_abilities,0,9);
		// get new abilities
		for(var i=0;i<9;i++)
		{
			switch(i)
			{
				case 0: _type = ""; break; 
				case 1: _type = ""; break; 
				case 2: _type = ""; break; 
				case 3: _type = ""; break; 
				case 4: _type = ""; break; 
				case 5: _type = ""; break; 
				case 6: _type = ""; break; 
				case 7: _type = ""; break; 
				case 8: _type = ""; break; 
			}
			// create abilites and add them to initial and stored ability arrays
			current_player_abilities[i] = new Ability(_type);
		}
	}
}
function ability_scheme_set_basictower(){
	with(global.iEngine)
	{
		var _type = "";
		// clear the current abilities
		array_delete(current_player_abilities,0,9);
		// get new abilities
		for(var i=0;i<9;i++)
		{
			switch(i)
			{
				case 0: _type = "barricade"; break; 
				case 1: _type = "gunturret"; break; 
				case 2: _type = "sniperturret"; break; 
				case 3: _type = "barracks"; break; 
				case 4: _type = "dronesilo"; break; 
				case 5: _type = "flameturret"; break; 
				case 6: _type = "mortarturret"; break; 
				case 7: _type = "toggle_info"; break; 
				case 8: _type = "sell_towers"; break;
			}
			// create abilites and add them to initial and stored ability arrays
			current_player_abilities[i] = new Ability(_type);
		}
	}
}
function ability_scheme_set_specialtower(){
	with(global.iEngine)
	{
		var _type = "";
		// clear the current abilities
		array_delete(current_player_abilities,0,9);
		// get new abilities
		for(var i=0;i<9;i++)
		{
			switch(i)
			{
			case 0: _type = "barricade"; break; 
			case 1: _type = "gunturret"; break; 
			case 2: _type = "sniperturret"; break; 
			case 3: _type = "barracks"; break; 
			case 4: _type = "dronesilo"; break; 
			case 5: _type = "flameturret"; break; 
			case 6: _type = "mortarturret"; break; 
			case 7: _type = "toggle_info"; break; 
			case 8: _type = "sell_towers"; break;
			}
			// create abilites and add them to initial and stored ability arrays
			current_player_abilities[i] = new Ability(_type);
		}
	}
}