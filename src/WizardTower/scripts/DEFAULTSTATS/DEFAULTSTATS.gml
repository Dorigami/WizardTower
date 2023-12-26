FighterStats = function() constructor{
    // UNITS
    summoner = { // support unit
        name : "default name",
		entity_type : UNIT,
        description : "default description",
        build_time : 2, // seconds
        supply_cost : 1,
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
        obj : oSummoner,
        bunker_size : 0,
		collision_radius : round(0.3*GRID_SIZE),
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
    marine = { // mid-range fighter
        name : "Marine",
		entity_type : UNIT,
        description : "default description",
        build_time : 2,
        supply_cost : 1,
        supply_capacity : 0,
        material_cost : 30,
		material_reward : 100,
        hp : 10,
        strength : 3,
        defense : 1,
        speed : 1,
        range : 2,
        tags : [],
        size : [1,1], // [width , height]
        obj : oMarine,
        bunker_size : 0,
		collision_radius : round(0.3*GRID_SIZE),
        basic_attack : {
			name : "Lens Flare",
			cooldown : 0.5, // delay, in seconds, between attacks
			move_penalty : 1.0, // move speed reduced during attack
			duration : 0.2, // movement is reduced, other attacks cannot be done during this time
			damage_point : 1, // damage is dealt after this step count
			damage_value : 1,
			damage_obj : oMarineBasic 
		},
        active_attack : {
		    name : "Focus Beam",
		    cooldown : 5, // delay, in seconds, between attacks
		    move_penalty : 0.8, // move speed reduced during attack
		    duration : 1.5, // movement is reduced, other attacks cannot be done during this time
		    damage_point : 10, // damage is dealt after this step count
		    damage_value : 1,
		    damage_obj : oMarineActive 
		}
    }
    drone = { // mid-range fighter
        name : "Drone",
		entity_type : UNIT,
        description : "default description",
        build_time : 2,
        supply_cost : 1,
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
        obj : oDrone,
        bunker_size : 0,
		collision_radius : round(0.3*GRID_SIZE),
        basic_attack : {
			name : "Lens Flare",
			cooldown : 10, // delay, in seconds, between attacks
			move_penalty : 0, // move speed reduced during attack
			duration : 0.8, // movement is reduced, other attacks cannot be done during this time
			damage_point : FRAME_RATE*0.6, // damage is dealt after this step count
			damage_value : 1,
			damage_obj : oDroneBasic 
		},
        active_attack : {
		    name : "Focus Beam",
		    cooldown : 5, // delay, in seconds, between attacks
		    move_penalty : 0.8, // move speed reduced during attack
		    duration : 1.5, // movement is reduced, other attacks cannot be done during this time
		    damage_point : 10, // damage is dealt after this step count
		    damage_value : 1,
		    damage_obj : oDroneActive 
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
	    hp : 50,
	    strength : 0,
	    defense : 1,
	    speed : 0,
	    range : 0,
	    tags : [],
	    obj : oBarricade,
	    size : [1,1], // [width , height]
	    bunker_size : 0,
		collision_radius : round(0.6*GRID_SIZE),
	    basic_attack : {
	        name : "Thrust Spear",
	        cooldown : 5, // delay, in seconds, between attacks
	        move_penalty : 0.8, // move speed reduced during attack
	        duration : 0.5, // movement is reduced, other attacks cannot be done during this time
	        damage_point : 10, // damage is dealt after this step count
	        damage_value : 1,
	        damage_obj : oGunTurretBasic 
	    },
	    active_attack : {
	        name : "Throw Spear",
	        cooldown : 5, // delay, in seconds, between attacks
	        move_penalty : 0.8, // move speed reduced during attack
	        duration : 1.5, // movement is reduced, other attacks cannot be done during this time
	        damage_point : 10, // damage is dealt after this step count
	        damage_value : 1,
	        damage_obj : oGunTurretActive 
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
	    range : 2,
	    tags : [],
	    obj : oGunTurret,
	    size : [1,1], // [width , height]
	    bunker_size : 0,
		collision_radius : round(0.6*GRID_SIZE),
	    basic_attack : {
	        name : "Thrust Spear",
	        cooldown : 2, // delay, in seconds, between attacks
	        move_penalty : 0.8, // move speed reduced during attack
	        duration : 0.5, // movement is reduced, other attacks cannot be done during this time
	        damage_point : 10, // damage is dealt after this step count
	        damage_value : 1,
	        damage_obj : oGunTurretBasic 
	    },
	    active_attack : {
	        name : "Throw Spear",
	        cooldown : 5, // delay, in seconds, between attacks
	        move_penalty : 0.8, // move speed reduced during attack
	        duration : 1.5, // movement is reduced, other attacks cannot be done during this time
	        damage_point : 10, // damage is dealt after this step count
	        damage_value : 1,
	        damage_obj : oGunTurretActive 
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
	    range : 2,
	    tags : [],
	    obj : oSniperTurret,
	    size : [1,1], // [width , height]
	    bunker_size : 0,
		collision_radius : round(0.6*GRID_SIZE),
	    basic_attack : {
	        name : "Thrust Spear",
	        cooldown : 6, // delay, in seconds, between attacks
	        move_penalty : 0.8, // move speed reduced during attack
	        duration : 0.5, // movement is reduced, other attacks cannot be done during this time
	        damage_point : 10, // damage is dealt after this step count
	        damage_value : 6,
	        damage_obj : oSniperBasic 
	    },
	    active_attack : {
	        name : "Throw Spear",
	        cooldown : 5, // delay, in seconds, between attacks
	        move_penalty : 0.8, // move speed reduced during attack
	        duration : 1.5, // movement is reduced, other attacks cannot be done during this time
	        damage_point : 10, // damage is dealt after this step count
	        damage_value : 1,
	        damage_obj : oSniperActive 
	    }
	}
	barracks = {
		name : "barracks",
	    description : "default description",
		entity_type : STRUCTURE,
	    build_time : 1,
	    supply_cost : 1,
	    supply_capacity : 5,
	    material_cost : 10,
		material_reward : 100,
	    hp : 5,
	    strength : 3,
	    defense : 1,
	    speed : 0,
	    range : 2,
	    tags : [],
	    obj : oBarracks,
	    size : [1,1], // [width , height]
	    bunker_size : 0,
		collision_radius : round(0.6*GRID_SIZE),
	    basic_attack : {
	        name : "Thrust Spear",
	        cooldown : 5, // delay, in seconds, between attacks
	        move_penalty : 0.8, // move speed reduced during attack
	        duration : 1.5, // movement is reduced, other attacks cannot be done during this time
	        damage_point : 20, // damage is dealt after this step count
	        damage_value : 0,
	        damage_obj : oBarracksBasic 
	    },
	    active_attack : {
	        name : "Throw Spear",
	        cooldown : 5, // delay, in seconds, between attacks
	        move_penalty : 0.8, // move speed reduced during attack
	        duration : 1.5, // movement is reduced, other attacks cannot be done during this time
	        damage_point : 10, // damage is dealt after this step count
	        damage_value : 1,
	        damage_obj : oBarracksActive 
	    }
	}
	dronesilo = {
		name : "Drone Silo",
	    description : "default description",
		entity_type : STRUCTURE,
	    build_time : 1,
	    supply_cost : 1,
	    supply_capacity : 2,
	    material_cost : 10,
		material_reward : 100,
	    hp : 5,
	    strength : 3,
	    defense : 1,
	    speed : 0,
	    range : 2,
	    tags : [],
	    obj : oDroneSilo,
	    size : [1,1], // [width , height]
	    bunker_size : 0,
		collision_radius : round(0.6*GRID_SIZE),
	    basic_attack : {
	        name : "Thrust Spear",
	        cooldown : 5, // delay, in seconds, between attacks
	        move_penalty : 0.8, // move speed reduced during attack
	        duration : 0.5, // movement is reduced, other attacks cannot be done during this time
	        damage_point : 10, // damage is dealt after this step count
	        damage_value : 1,
	        damage_obj : oDroneSiloBasic 
	    },
	    active_attack : {
	        name : "Throw Spear",
	        cooldown : 5, // delay, in seconds, between attacks
	        move_penalty : 0.8, // move speed reduced during attack
	        duration : 1.5, // movement is reduced, other attacks cannot be done during this time
	        damage_point : 10, // damage is dealt after this step count
	        damage_value : 1,
	        damage_obj : oDroneSiloActive 
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
	    hp : 20,
	    strength : 3,
	    defense : 1,
	    speed : 0,
	    range : 1,
	    tags : [],
	    obj : oFlameTurret,
	    size : [1,1], // [width , height]
	    bunker_size : 0,
		collision_radius : round(0.6*GRID_SIZE),
	    basic_attack : {
	        name : "Thrust Spear",
	        cooldown : 5, // delay, in seconds, between attacks
	        move_penalty : 0.8, // move speed reduced during attack
	        duration : 0.5, // movement is reduced, other attacks cannot be done during this time
	        damage_point : 10, // damage is dealt after this step count
	        damage_value : 1,
	        damage_obj : oFlameTurretBasic 
	    },
	    active_attack : {
	        name : "Throw Spear",
	        cooldown : 5, // delay, in seconds, between attacks
	        move_penalty : 0.8, // move speed reduced during attack
	        duration : 1.5, // movement is reduced, other attacks cannot be done during this time
	        damage_point : 10, // damage is dealt after this step count
	        damage_value : 1,
	        damage_obj : oFlameTurretActive 
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
	    range : 3,
	    tags : [],
	    obj : oMortarTurret,
	    size : [1,1], // [width , height]
	    bunker_size : 0,
		collision_radius : round(0.6*GRID_SIZE),
	    basic_attack : {
	        name : "Thrust Spear",
	        cooldown : 1, // delay, in seconds, between attacks
	        move_penalty : 0.8, // move speed reduced during attack
	        duration : 1, // movement is reduced, other attacks cannot be done during this time
	        damage_point : 0.5*FRAME_RATE, // damage is dealt after this step count
	        damage_value : 3,
	        damage_obj : oMortarTurretBasic 
	    },
	    active_attack : {
	        name : "Throw Spear",
	        cooldown : 5, // delay, in seconds, between attacks
	        move_penalty : 0.8, // move speed reduced during attack
	        duration : 1.5, // movement is reduced, other attacks cannot be done during this time
	        damage_point : 10, // damage is dealt after this step count
	        damage_value : 1,
	        damage_obj : oMortarTurretActive 
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
		collision_radius : round(0.3*GRID_SIZE),
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
		collision_radius : round(0.3*GRID_SIZE),
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
		collision_radius : round(0.3*GRID_SIZE),
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
		collision_radius : round(0.3*GRID_SIZE),
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
		collision_radius : round(0.3*GRID_SIZE),
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
		collision_radius : round(0.3*GRID_SIZE),
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
