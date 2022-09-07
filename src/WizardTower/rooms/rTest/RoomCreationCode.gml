
// initialize the paths, indicate whether they are used or not by setting 'closed'
path_set_closed(global.mobPaths[0], false);
path_set_closed(global.mobPaths[1], true);
path_set_closed(global.mobPaths[2], true);
path_set_closed(global.mobPaths[3], true);
path_set_closed(global.mobPaths[4], true);
path_set_closed(global.mobPaths[5], true);

// give data for the spawn timeline
var _data = [
{ moment : 000, path : pathMob0, type : 0, groupSize : 8, mutators : -1 },
{ moment : 200, path : pathMob0, type : 1, groupSize : 8, mutators : -1 },
{ moment : 200, path : pathMob0, type : 2, groupSize : 8, mutators : -1 },
{ moment : 400, path : pathMob0, type : 2, groupSize : 8, mutators : -1 },
{ moment : 600, path : pathMob0, type : 3, groupSize : 8, mutators : -1 },
{ moment : 800, path : pathMob0, type : 4, groupSize : 8, mutators : -1 }
];

TimelineSetData(_data);
