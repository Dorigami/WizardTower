/// @description 

if(global.mouse_focus == id) global.mouse_focus = noone;

if(faction_list_index == -1) exit;

// remove entity from entity list
var _diff = 0;
var _actor = global.iEngine.actor_list[| faction];
var _stats = _actor.fighter_stats[$ type_string];
var _ind = -1;

// if the entity is a member of a Mob object, remove it from the members list
if(member_of != noone) && (!is_undefined(member_of))
{
    ds_list_delete(member_of.members,ds_list_find_index(member_of.members, id))
}

// if the entity is selected, remove it from that list
if(selected){
	var _pos = ds_list_find_index(_actor.selected_entities, id);
	if(_pos > -1) ds_list_delete(_actor.selected_entities, _pos);
}

// if the entity is a blueprint, remove it from that faction's blueprint list
if(!is_undefined(blueprint)){
	// delete the hex_path_list
	if(ds_exists(hex_path_list, ds_type_list)) ds_list_destroy(hex_path_list);
    _diff = _actor.blueprint_count - faction_list_index;
    if(_diff > 1){
        for(var i=1; i<_diff; i++){
            _entity = _actor.blueprints[| faction_list_index+i];
            if(!is_undefined(_entity)) _entity.faction_list_index--;
        }
    }
    ds_list_delete(_actor.blueprints, faction_list_index);
    _actor.blueprint_count--;
	
	// remove supply from the actor
	if(!is_undefined(fighter)) && (fighter.hp <= 0) _actor.supply_in_queue -= _stats.supply_cost;
	
    // clear id from occupy cells
	with(global.i_hex_grid)
	{
		var _hex_index =  hex_get_index(other.hex);
		var _hex_container = hexarr_containers[_hex_index];
		var _container_index = ds_list_find_index(_hex_container, other.id);
	}
	if( _container_index != -1) ds_list_delete(_hex_container, _container_index);
} 

// if the entity is a unit, remove it from that faction's unit list
if(!is_undefined(unit)) || (!is_undefined(structure)){
	// delete the hex_path_list
	if(ds_exists(hex_path_list, ds_type_list)) ds_list_destroy(hex_path_list);

	// remove supply from the actor
	if(!is_undefined(fighter)) && (fighter.hp <= 0) _actor.supply_current -= _stats.supply_cost;
	
    // clear id from occupy cells
	with(global.i_hex_grid)
	{
		var _hex_index =  hex_get_index(other.hex);
		var _hex_container = hexarr_containers[_hex_index];
		var _container_index = ds_list_find_index(_hex_container, other.id);
	}
	if( _container_index != -1) ds_list_delete(_hex_container, _container_index);
} 

// remove components
if(!is_undefined(blueprint)) { blueprint.Destroy(); delete blueprint } 
if(!is_undefined(fighter)) { fighter.Destroy(); delete fighter } 
if(!is_undefined(unit)) { unit.Destroy(); delete unit } 
if(!is_undefined(structure)) { structure.Destroy(); delete structure } 
if(!is_undefined(bunker)) { bunker.Destroy(); delete bunker } 
if(!is_undefined(ai)) { ai.Destroy(); delete ai }
if(!is_undefined(interactable)) { interactable.Destroy(); delete interactable } 
