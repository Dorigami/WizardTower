/// @description 

/*

event_inherited();

function AddDrone(_obj){
	switch(_obj)
	{
		case oDroneA:
			statPower += 0.1;
			break;
		case oDroneB:
			statResource2 += 20;
			break;
		case oDroneC:
			statResource1 += 20;
			break;
	}
	with(instance_create_layer(x, y, "Instances", _obj))
	{
		creator = other.id;
		spd = creator.statMovespeed;
		ds_list_add(other.droneList, id);
	}
	CalculateSpriteSize();
}
//-------------------


hp = statHealth;
rsc1 = statResource1;
rsc2 = statResource2;

droneList = ds_list_create();
droneBehavior = DroneBehaviorSwarmCreator;
stateScript[STATE.INTERACT] = AttackerInteract;
stateScript[STATE.ATTACK] = AttackerAttack;
size = 80;

CalculateSpriteSize();

