/// @description Initialize

image_alpha = 0.4;

len_ = 0;
dir_ = 0;
enabled = false;

function EmptySelection(_actor){
	var _size = ds_list_size(_actor.selected_entities);
	
	for(var i=0;i<_size;i++) _actor.selected_entities[| i].selected = false;

	ds_list_clear(_actor.selected_entities);
	
	global.iEngine.sell_price = 0;
	
	// update the hud for displaying selected entities
	if(_actor.faction == PLAYER_FACTION)
	{
		global.iHUD.show_selected_entities = ds_list_size(_actor.selected_entities);
	}
	with(oSelectionInspector) inspect(noone);
	// revert player abilities to their default
	ability_scheme_set();
}

function EnableSelection(){
    enabled = true;
    x = mouse_x;
    y = mouse_y;
    show_debug_message("Enable Selection");
}

function ConfirmSelection(){
	var _player_actor = global.iEngine.player_actor;
	var _val = 0, i = 0, _inst = noone, _ent = undefined, _offset = 0, _valid = true;
	var _has_units = false;
	var _has_structures = false;
	var _faction_index = 100; // set to arbitrary high faction, as this is the highest index to reference
	var _tmp = ds_list_create();
	var _plist = _player_actor.selected_entities;
	EmptySelection(_player_actor);
//**// this is edited to only allow single selection instead of group selection
/*
	if(visible){
		_val = instance_place_list(x,y,pEntity,_tmp,false);
		if(_val > 0){
			// filter the selection
			for(i=0;i<_val;i++){
				// 1a) loop through to find the lowest actor/faction index.
				// 1b) see if structures or units were selected.
				_ent = _tmp[| i];
				if(_faction_index != PLAYER_FACTION) && (_faction_index > _ent.faction) _faction_index = _ent.faction;
				if(!_has_units) && (!is_undefined(_ent.unit)) { _has_units = true; }
				if(!_has_structures) && (!is_undefined(_ent.structure)) { _has_structures = true; }
			}
			for(i=0;i<_val;i++){
				// 2) loop again, removing applicable IDs
				_valid = true;
				_ent = _tmp[| i];
				if(_ent.faction != _faction_index) _valid = false;
				if(_has_units) 
				{   // only add units if a unit is among the entities
					if(is_undefined(_ent.unit)) _valid = false;
				} else if(_has_structures){
					// only add structures if there weren't any units among entities
					if(is_undefined(_ent.structure)) _valid = false;
				} 
				if(_valid) {
					if(_ent.object_index == oMarine) || (_ent.object_index == oDrone)
					{
						if(ds_list_find_index(_plist,_ent.creator) == -1){ 
							_ent.creator.selected = true;
							ds_list_add(_plist, _ent.creator) 
						}
					} else {
						_ent.selected = true;
						ds_list_add(_plist, _ent);
						if(global.game_state == GameStates.SELLING)
						{
							if(_ent.faction == PLAYER_FACTION) && (_ent.entity_type == STRUCTURE)
							{
								global.iEngine.sell_price += _ent.material_cost;
							}
						}
					}
				}
			}
		}
	} else {
*/
		// if the selection area is small enough, just get 1 instance at location
		_ent = instance_place(mouse_x,mouse_y,pEntity);
		if(_ent != noone) {	
			_ent.selected = true;
			if(is_undefined(_ent.blueprint)) ds_list_add(_plist, _ent);
			if(global.game_state == GameStates.SELLING)
			{
				if(_ent.faction == PLAYER_FACTION) && (_ent.entity_type == STRUCTURE)
				{
					global.iEngine.sell_price += _ent.material_cost;
				}
			}
			with(oSelectionInspector) inspect(_ent);
			if(_ent.faction != PLAYER_FACTION)
			{// default abilities if entity doesn't belong to the player
				ability_scheme_set();
			} else {
				// set abilities specific to the entity selected
				ability_scheme_set(_ent.abilities);
			}

		}
/*
	}
*/
	ds_list_destroy(_tmp);
	enabled = false;
    visible = false;
    global.iEngine.selecting = false;
	// update the hud for displaying selected entities
	global.iHUD.show_selected_entities = ds_list_size(global.iEngine.player_actor.selected_entities);
	
    show_debug_message("Confirm Selection");
}

function CancelSelection(){
	EmptySelection(global.iEngine.player_actor);
	enabled = false;
    visible = false;
    global.iEngine.selecting = false;
	// update the hud for displaying selected entities
	global.iHUD.show_selected_entities = ds_list_size(global.iEngine.player_actor.selected_entities);
	
    show_debug_message("Cancel Selection");
}
