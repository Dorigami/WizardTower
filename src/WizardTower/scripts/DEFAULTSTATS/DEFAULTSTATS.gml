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
        hp : 8,
        strength : 3,
        defense : 1,
        speed : 2,
        range : 5,
        tags : [],
        size : [1,1], // [width , height]
        //los_radius : 4,
        //build_radius : 0,
        //abilities : [ManualBasicAttack,ManualActiveAttack,-1,-1,-1,-1,-1,-1,-1],
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
    sentry = { // mid-range fighter
        name : "default name",
		entity_type : UNIT,
        description : "default description",
        build_time : 2,
        supply_cost : 2,
        supply_capacity : 0,
        material_cost : 30,
		material_reward : 100,
        hp : 10,
        strength : 3,
        defense : 1,
        speed : 1,
        range : 3,
        tags : [],
        size : [1,1], // [width , height]
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

/* ---- PLAYER STRUCTURES ---- */
	barricade = {
		name : "barricade",
	    description : "default description",
		entity_type : STRUCTURE,
	    build_time : 1,
	    supply_cost : 1,
	    supply_capacity : 0,
	    material_cost : 10,
		material_reward : 100,
	    hp : 5,
	    strength : 3,
	    defense : 1,
	    speed : 0,
	    range : 4,
	    tags : [],
	    obj : oBarricade,
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
	gunturret = {
		name : "gunner turret",
	    description : "default description",
		entity_type : STRUCTURE,
	    build_time : 1,
	    supply_cost : 1,
	    supply_capacity : 0,
	    material_cost : 10,
		material_reward : 100,
	    hp : 5,
	    strength : 3,
	    defense : 1,
	    speed : 0,
	    range : 4,
	    tags : [],
	    obj : oGunTurret,
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
	sniperturret = {
		name : "sniper turret",
	    description : "default description",
		entity_type : STRUCTURE,
	    build_time : 1,
	    supply_cost : 1,
	    supply_capacity : 0,
	    material_cost : 10,
		material_reward : 100,
	    hp : 5,
	    strength : 3,
	    defense : 1,
	    speed : 0,
	    range : 4,
	    tags : [],
	    obj : oSniperTurret,
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
	barracks = {
		name : "barracks",
	    description : "default description",
		entity_type : STRUCTURE,
	    build_time : 1,
	    supply_cost : 1,
	    supply_capacity : 0,
	    material_cost : 10,
		material_reward : 100,
	    hp : 5,
	    strength : 3,
	    defense : 1,
	    speed : 0,
	    range : 4,
	    tags : [],
	    obj : oBarracks,
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
	dronesilo = {
		name : "Drone Silo",
	    description : "default description",
		entity_type : STRUCTURE,
	    build_time : 1,
	    supply_cost : 1,
	    supply_capacity : 0,
	    material_cost : 10,
		material_reward : 100,
	    hp : 5,
	    strength : 3,
	    defense : 1,
	    speed : 0,
	    range : 4,
	    tags : [],
	    obj : oDroneSilo,
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
	flameturret = {
		name : "flame turret",
	    description : "default description",
		entity_type : STRUCTURE,
	    build_time : 1,
	    supply_cost : 1,
	    supply_capacity : 0,
	    material_cost : 10,
		material_reward : 100,
	    hp : 5,
	    strength : 3,
	    defense : 1,
	    speed : 0,
	    range : 4,
	    tags : [],
	    obj : oFlameTurret,
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
	mortarturret = {
		name : "mortar turret",
	    description : "default description",
		entity_type : STRUCTURE,
	    build_time : 1,
	    supply_cost : 1,
	    supply_capacity : 0,
	    material_cost : 10,
		material_reward : 100,
	    hp : 5,
	    strength : 3,
	    defense : 1,
	    speed : 0,
	    range : 4,
	    tags : [],
	    obj : oMortarTurret,
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


/* ---- ENEMY UNITS ---- */
    skeleton = { // basic enemy unit
        name : "default name",
		entity_type : UNIT,
        description : "default description",
        build_time : 2,
        supply_cost : 1,
        supply_capacity : 0,
        material_cost : 30,
		material_reward : 100,
        hp : 4,
        strength : 3,
        defense : 1,
        speed : 1,
        range : 0,
        tags : [],
        size : [1,1], // [width , height]
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
    marcher = { // basic enemy unit
        name : "default name",
		entity_type : UNIT,
        description : "default description",
        build_time : 2,
        supply_cost : 1,
        supply_capacity : 0,
        material_cost : 30,
		material_reward : 100,
        hp : 4,
        strength : 3,
        defense : 1,
        speed : 1,
        range : 0,
        tags : [],
        size : [1,1], // [width , height]
        obj : oMarcher,
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
    swarmer = { 
        name : "default name",
		entity_type : UNIT,
        description : "default description",
        build_time : 2,
        supply_cost : 1,
        supply_capacity : 0,
        material_cost : 30,
		material_reward : 100,
        hp : 4,
        strength : 3,
        defense : 1,
        speed : 1,
        range : 0,
        tags : [],
        size : [1,1], // [width , height]
        obj : oSwarmer,
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
    buildingkiller = { // basic enemy unit
        name : "default name",
		entity_type : UNIT,
        description : "default description",
        build_time : 2,
        supply_cost : 1,
        supply_capacity : 0,
        material_cost : 30,
		material_reward : 100,
        hp : 4,
        strength : 3,
        defense : 1,
        speed : 1,
        range : 0,
        tags : [],
        size : [1,1], // [width , height]
        obj : oBuildingKiller,
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
    unitkiller = { 
        name : "default name",
		entity_type : UNIT,
        description : "default description",
        build_time : 2,
        supply_cost : 1,
        supply_capacity : 0,
        material_cost : 30,
		material_reward : 100,
        hp : 4,
        strength : 3,
        defense : 1,
        speed : 1,
        range : 0,
        tags : [],
        size : [1,1], // [width , height]
        obj : oUnitKiller,
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
    goliath = {
        name : "default name",
		entity_type : UNIT,
        description : "default description",
        build_time : 2,
        supply_cost : 1,
        supply_capacity : 0,
        material_cost : 30,
		material_reward : 100,
        hp : 4,
        strength : 3,
        defense : 1,
        speed : 1,
        range : 0,
        tags : [],
        size : [1,1], // [width , height]
        obj : oGoliath,
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
}
