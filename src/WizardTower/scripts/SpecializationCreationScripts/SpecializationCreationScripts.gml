function ChangeEntitySpecialization(_type){
	 // the instance is needed in order to replace the existing tower with the specialized version
	 var _inst = global.iEngine.player_actor.selected_entities[| 0];
	 // exit if the entity doesn't exist
	 if(is_undefined(_inst)) || (_inst == noone) || (!instance_exists(_inst)) exit;
	 
	 // create the new tower, with some data coming from the old one
	 with(ConstructStructure(_inst.x,_inst.y,_inst.faction,_type,true,true))
	 {
		fighter.kill_count = _inst.fighter.kill_count;
		global.iEngine.player_actor.selected_entities[| 0] = id;
		with(oSelectionInspector){ inspect(other.id) }
	 }
	 
	 // visual effect for upgrading
	 UpgradeEffectCreate(_inst.x,_inst.y);
	 
	 // remove old entity
	 instance_destroy(_inst); 
}

