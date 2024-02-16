function KillEntity(_ent){
	if(object_exists(_ent.fighter.death_object)) instance_create_layer(_ent.x, _ent.y, "Instances", _ent.fighter.death_object);
	with(_ent){ if(sound_death != snd_empty) SoundCommand(sound_death, x, y) }
	ds_queue_enqueue(global.iEngine.killing_floor,_ent);
}