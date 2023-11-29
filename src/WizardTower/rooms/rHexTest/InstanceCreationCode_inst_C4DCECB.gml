data = ds_list_create();

#macro M "marcher"
#macro S "swarmer"
#macro B "buildingkiller"
#macro U "unitkiller"
#macro G "goliath"

// each index of the list will contain
var _content = ds_queue_create();

/*
	moment = {
		timestamp : [
			['unit', 'count', 'power'],
		]
	}
*/

	wave_content = {
		wave1 : { // the 'key' in this struct is moment in milliseconds, the 'value' is an array of the units to spawn & their spawn location 
			time : 20000, 
			instance : noone,
			complete : false,
			ms1 : [
				[M, 1, 1],
				[S, 1, 1],
				[B, 1, 1],
				[U, 1, 1],
				[G, 1, 1]
			],
			ms5000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
			],
			ms10000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
			],
			ms15000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
			],
			ms20000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
			]
		},
		wave2 : {
			time : 22000, 
			instance : noone,
			complete : false,
			ms1 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1] 
			],
			ms5000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms10000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms15000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms20000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			]
		},
		wave3 : {
			time : 25000, 
			instance : noone,
			complete : false,
			ms1 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1] 
			],
			ms5000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms10000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms15000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms20000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			]
		},
		wave4 : {
			time : 250000, 
			instance : noone,
			complete : false,
			ms1 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1] 
			],
			ms5000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms10000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms15000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			],
			ms20000 : [
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1],
				["skeleton", 1, 1]
			]
		}
	}
