#macro M "marcher"
#macro S "swarmer"
#macro B "buildingkiller"
#macro U "unitkiller"
#macro G "goliath"

/*
  -- here is how the level/wave data is structured --
	wave# = {
		timestamp/moment : [
			'spawn node index', (the first element in the array will say which node to spawn all the enemies in)
			['unit', 'count', 'power'],
		]
	}
*/

level_content = {
	wave0 : { // the 'key' in this struct is moment in milliseconds, the 'value' is an array of the units to spawn & their spawn location 
		ms1 : [ 0, [M, 1, 1],[S, 0, 1],[B, 0, 1],[U, 0, 1],[G, 0, 1] ],
		ms10000 : [ 0, [M, 2, 1],[S, 0, 1],[B, 0, 1],[U, 0, 1],[G, 0, 1] ],
		ms15000 : [] // this is timestamp at which the wave ends
	},
	wave1 : {
		ms1 : [ 0, [M, 1, 1],[S, 1, 1],[B, 0, 1],[U, 0, 1],[G, 0, 1] ],
		ms5000 : [ 0, [M, 1, 1],[S, 1, 1],[B, 0, 1],[U, 0, 1],[G, 0, 1] ],
		ms10000 : [ 0, [M, 1, 1],[S, 1, 1],[B, 0, 1],[U, 0, 1],[G, 0, 1] ],
		ms15000 : [] // this is timestamp at which the wave ends
	},
	wave2 : {
		ms1 : [ 0, [M, 0, 1],[S, 0, 1],[B, 0, 1],[U, 1, 1],[G, 0, 1] ],
		ms5000 : [ 0, [M, 0, 1],[S, 0, 1],[B, 0, 1],[U, 1, 1],[G, 0, 1] ],
		ms10000 : [ 0, [M, 0, 1],[S, 0, 1],[B, 0, 1],[U, 1, 1],[G, 0, 1] ],
		ms15000 : [] // this is timestamp at which the wave ends
	},
	wave3 : {
		ms1 : [ 0, [M, 0, 1],[S, 0, 1],[B, 0, 1],[U, 0, 1],[G, 1, 1] ],
		ms5000 : [ 0, [M, 0, 1],[S, 0, 1],[B, 0, 1],[U, 0, 1],[G, 1, 1] ],
		ms10000 : [ 0, [M, 0, 1],[S, 0, 1],[B, 0, 1],[U, 0, 1],[G, 1, 1] ],
		ms15000 : [] // this is timestamp at which the wave ends
	}
}

