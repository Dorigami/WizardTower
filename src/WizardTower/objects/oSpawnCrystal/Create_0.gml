/// @description 

// Inherit the parent event
event_inherited();

stateScript[STATE.SPAWN] = StructureSpawn;
stateScript[STATE.FREE] = StructureFree;
stateScript[STATE.ATTACK] = StructureFree;
stateScript[STATE.BUILD] = -1;
stateScript[STATE.GATHER] = -1;
stateScript[STATE.DEAD] = StructureDead;

radialArgs = [[oButtonRadial,sImpRadial,x,y,"",false,RadialSpawnEnemy,[oUnitGrunt],RadialSpawnEnemy,[oUnitGrunt]]
			 ];
radialOptions = array_create(array_length(radialArgs),noone);
