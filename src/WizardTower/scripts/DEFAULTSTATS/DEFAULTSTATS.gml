
//--//  spearbearer | physical dps (throw spear dealing damage, unit can't attack while on cooldown but can retrieve the spear to reset the cooldown)
//--// summoner | physical support (greatly raise defense and mass, but cannot move or attack)
//--//   lensbearer | magical dps (lock onto a target, dealing ramping damage for duration of the attack)
//--//  torchbearer | magical support (illuminate to increase vision radius and damage nearby enemies, reduces movement speed)

//--//         Base | starting point for the player, these cannot be constructed by the player
//--//      Conduit | build to increase supply capacity
//--//         Lamp | build to gain increased line of sight to nearby tiles
//--//     Workshop | build to gain access to structure upgrades
//--//       Armory | build to gain access to unit upgrades
//--//       Turret | build to create stationary, ranged defenses to fight off enemies
//--//    Barricade | build to create a barrier, preventing grounded units from passing through

FighterStats = function() constructor{
    // UNITS
    summoner = { // support unit
        name : "default name",
		entity_type : UNIT,
        description : "default description",
        build_time : 2, // seconds
        supply_cost : 2,
        supply_capacity : 0,
        material_cost : 20,
		material_reward : 100,
        experience_reward : 100,
		upgrade_reward : 100,
		jump : 3,
        hp : 8,
        strength : 3,
        defense : 1,
        speed : 2,
        range : 5,
        tags : [],
        size : [1,1], // [width , height]
        los_radius : 4,
        build_radius : 0,
        abilities : [ManualBasicAttack,ManualActiveAttack,-1,-1,-1,-1,-1,-1,-1],
        obj : oSummoner,
        bunker_size : 0,
        basic_attack : {
		    name : "Shield Bash",
		    cooldown : 5, // delay, in seconds, between attacks
		    move_penalty : 0.8, // move speed reduced during attack
		    duration : 0.5, // movement is reduced, other attacks cannot be done during this time
		    damage_point : 10, // damage is dealt after this step count
		    damage_value : 1,
		    damage_obj : oSummonerBasic 
		},
        active_attack : {
		    name : "Bulwark",
		    cooldown : 5, // delay, in seconds, between attacks
		    move_penalty : 0.8, // move speed reduced during attack
		    duration : 1.5, // movement is reduced, other attacks cannot be done during this time
		    damage_point : 10, // damage is dealt after this step count
		    damage_value : 1,
		    damage_obj : oSummonerActive 
		}
    }
    spearbearer = { // melee fighter
        name : "default name",
		entity_type : UNIT,
        description : "default description",
        build_time : 2, // seconds
        supply_cost : 2,
        supply_capacity : 0,
        material_cost : 20,
		material_reward : 100,
        experience_reward : 100,
		upgrade_reward : 100,
        jump : 3,
        hp : 8,
        strength : 3,
        defense : 1,
        speed : 2,
        range : 2,
        tags : [],
        size : [1,1], // [width , height]
        los_radius : 4,
        build_radius : 0,
        abilities : [ManualBasicAttack,ManualActiveAttack,-1,-1,-1,-1,-1,-1,-1],
        obj : oSpearBearer,
        bunker_size : 0,
        basic_attack : {
		    name : "Thrust Spear",
		    cooldown : 5, // delay, in seconds, between attacks
		    move_penalty : 0.8, // move speed reduced during attack
		    duration : 0.5, // movement is reduced, other attacks cannot be done during this time
		    damage_point : 10, // damage is dealt after this step count
		    damage_value : 1,
		    damage_obj : oSpearBasic 
		},
        active_attack : {
		    name : "Throw Spear",
		    cooldown : 5, // delay, in seconds, between attacks
		    move_penalty : 0.8, // move speed reduced during attack
		    duration : 1.5, // movement is reduced, other attacks cannot be done during this time
		    damage_point : 10, // damage is dealt after this step count
		    damage_value : 1,
		    damage_obj : oSpearActive 
		}
    }
    sentry = { // mid-range fighter
        name : "default name",
		entity_type : UNIT,
        description : "default description",
        build_time : 2,
        supply_cost : 2,
        supply_capacity : 0,
        material_cost : 30,
		material_reward : 100,
        experience_reward : 100,
		upgrade_reward : 100,
        jump : 3,
        hp : 10,
        strength : 3,
        defense : 1,
        speed : 1,
        range : 3,
        tags : [],
        size : [1,1], // [width , height]
        los_radius : 4,
        build_radius : 0,
        abilities : [ManualBasicAttack,ManualActiveAttack,-1,-1,-1,-1,-1,-1,-1],
        obj : oSentry,
        bunker_size : 0,
        basic_attack : {
			name : "Lens Flare",
			cooldown : 0.2, // delay, in seconds, between attacks
			move_penalty : 0, // move speed reduced during attack
			duration : 0.2, // movement is reduced, other attacks cannot be done during this time
			damage_point : 1, // damage is dealt after this step count
			damage_value : 1,
			damage_obj : oSentryBasic 
		},
        active_attack : {
		    name : "Focus Beam",
		    cooldown : 5, // delay, in seconds, between attacks
		    move_penalty : 0.8, // move speed reduced during attack
		    duration : 1.5, // movement is reduced, other attacks cannot be done during this time
		    damage_point : 10, // damage is dealt after this step count
		    damage_value : 1,
		    damage_obj : oSentryActive 
		}
    }
    torchbearer = { // long-range fighter
        name : "default name",
		entity_type : UNIT,
        description : "default description",
        build_time : 2,
        supply_cost : 2,
        supply_capacity : 0,
        material_cost : 30,
		material_reward : 100,
        experience_reward : 100,
		upgrade_reward : 100,
        jump : 3,
        hp : 10,
        strength : 3,
        defense : 1,
        speed : 1,
        range : 2,
        tags : [],
        size : [1,1], // [width , height]
        los_radius : 4,
        build_radius : 0,
        abilities : [ManualBasicAttack,ManualActiveAttack,-1,-1,-1,-1,-1,-1,-1],
        obj : oTorchBearer,
        bunker_size : 0,
        basic_attack : {
		    name : "Immolate",
		    cooldown : 5, // delay, in seconds, between attacks
		    move_penalty : 0.8, // move speed reduced during attack
		    duration : 0.2, // movement is reduced, other attacks cannot be done during this time
		    damage_point : 10, // damage is dealt after this step count
		    damage_value : 1,
		    damage_obj : oTorchBasic 
		},
        active_attack : {
		    name : "Firelight Beacon",
		    cooldown : 5, // delay, in seconds, between attacks
		    move_penalty : 0.8, // move speed reduced during attack
		    duration : 1.5, // movement is reduced, other attacks cannot be done during this time
		    damage_point : 10, // damage is dealt after this step count
		    damage_value : 1,
		    damage_obj : oTorchActive 
		}
    }
    skeleton = { // basic enemy unit
        name : "default name",
		entity_type : UNIT,
        description : "default description",
        build_time : 2,
        supply_cost : 1,
        supply_capacity : 0,
        material_cost : 30,
		material_reward : 100,
        experience_reward : 100,
		upgrade_reward : 100,
        jump : 3,
        hp : 4,
        strength : 3,
        defense : 1,
        speed : 1,
        range : 0,
        tags : [],
        size : [1,1], // [width , height]
        los_radius : 4,
        build_radius : 0,
        abilities : [-1,-1,-1,-1,-1,-1,-1,-1,-1],
        obj : oSkeleton,
        bunker_size : 0,
        basic_attack : {
            name : "Bone Slash",
            cooldown : 2, // delay, in seconds, between attacks
            move_penalty : 1, // move speed reduced during attack
            duration : 0.5, // movement is reduced, other attacks cannot be done during this time
            damage_point : 10, // damage is dealt after this step count
            damage_value : 1,
            damage_obj : oSkeletonBasic 
        },
        active_attack : {
            name : "Throw Bone",
            cooldown : 5, // delay, in seconds, between attacks
            move_penalty : 1, // move speed reduced during attack
            duration : 1.5, // movement is reduced, other attacks cannot be done during this time
            damage_point : 10, // damage is dealt after this step count
            damage_value : 1,
            damage_obj : oSkeletonActive 
        }
    }

    // STRUCTURES
    turret = {
        name : "default name",
		entity_type : STRUCTURE,
        description : "default description",
        build_time : 1, 
        supply_cost : 1,
        supply_capacity : 0,
        material_cost : 50,
		material_reward : 100,
        experience_reward : 100,
		upgrade_reward : 100,
        hp : 5,
        strength : 3,
        defense : 1,
        speed : 0,
        range : 4,
        tags : [],
        los_radius : 1,
        build_radius : 0,
        abilities : [-1,-1,-1,-1,-1,-1,-1,-1,-1],
        obj : oTurret,
        size : [1,1], // [width , height]
        rally_offset : [0,3],
        bunker_size : 0,
        basic_attack : {
            name : "Thrust Spear",
            cooldown : 5, // delay, in seconds, between attacks
            move_penalty : 0.8, // move speed reduced during attack
            duration : 0.5, // movement is reduced, other attacks cannot be done during this time
            damage_point : 10, // damage is dealt after this step count
            damage_value : 1,
            damage_obj : oTurretBasic 
        },
        active_attack : {
            name : "Throw Spear",
            cooldown : 5, // delay, in seconds, between attacks
            move_penalty : 0.8, // move speed reduced during attack
            duration : 1.5, // movement is reduced, other attacks cannot be done during this time
            damage_point : 10, // damage is dealt after this step count
            damage_value : 1,
            damage_obj : oTurretActive 
        }
    }
    barricade = { // a wall to 
        name : "default name",
		entity_type : STRUCTURE,
        description : "default description",
        build_time : 1,
        supply_cost : 0,
        supply_capacity : 0,
        material_cost : 10,
		material_reward : 100,
        experience_reward : 100,
		upgrade_reward : 100,
        hp : 20,
        strength : 3,
        defense : 1,
        speed : 0,
        range : 0,
        tags : [],
        los_radius : 1,
        build_radius : 0,
        abilities : [-1,-1,-1,-1,-1,-1,-1,-1,-1],
        obj : oBarricade,
        size : [1,1], // [width , height]
        rally_offset : [0,3],
        bunker_size : 0,
        basic_attack : undefined,
        active_attack : undefined
    }
}
