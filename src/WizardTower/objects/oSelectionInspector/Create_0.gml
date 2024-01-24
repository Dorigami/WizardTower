/// @description 

target = noone;
inspect_script = -1;
function inspect(_inst){
	target = _inst;
	if(_inst == noone){
		inspect_script = -1;
	} else {
		if(_inst.entity_type == UNIT){
			inspect_script = _inst.faction == PLAYER_FACTION ? inspect_friendly_unit_draw : inspect_enemy_draw;
		} else if(_inst.entity_type == STRUCTURE){
			inspect_script = _inst.faction == PLAYER_FACTION ? inspect_friendly_structure_draw : inspect_enemy_draw;
		}
	}
}
function inspect_friendly_unit_draw(){
	draw_sprite(target.sprite_index,target.image_index,x,y);
}
function inspect_friendly_structure_draw(){
	draw_sprite(target.sprite_index,target.image_index,x,y);
}
function inspect_enemy_draw(){
	draw_sprite(target.sprite_index,target.image_index,x,y);
}










