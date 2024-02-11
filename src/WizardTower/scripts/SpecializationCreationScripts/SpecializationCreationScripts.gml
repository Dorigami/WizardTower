// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function SpecializationCreateMinigun(){
	 // the instance is needed in order to replace the existing tower with the specialized version
	 var _inst = global.iEngine.player_actor.selected_entities[| 0];
	 
	 // exit if the entity doesn't exist
	 if(is_undefined(_inst)) || (_inst == noone) || (!instance_exists(_inst)) exit;
	 
	 // create the new tower, with some data coming from the old one
	 with(ConstructStructure(_inst.x,_inst.y,_inst.faction,"minigunturret",true))
	 {
		fighter.kill_count = _inst.fighter.kill_count;
	 }
	 instance_destroy(_inst);
}
function SpecializationCreateSniper(_inst){

}
function SpecializationCreateMortar(_inst){

}

