// timeline init data function
function TimelineSetData(_data)
{
	with(global.iGame)
	{
		// have the game object store the data being used for the timeline
		if(is_undefined(_data)) 
		{
			_data = stageData;
		} else {
			stageData = _data;
		}
		// set the data
		if(!is_undefined(_data))
		{
			// get all unique moment times from the stage data
			var _markerList = ds_list_create();
			for(var i=0;i<array_length(_data);i++)
			{
				// get markers representing each moment, add them to a list
				if(ds_list_find_index(_markerList,_data[i].moment) == -1) ds_list_add(_markerList, _data[i].moment);
		
				// combine stage data into the timeline map
				var _mom = _data[i].moment;
				var _list = tlmap[? _mom];
				if(is_undefined(_list))
				{
					tlmap[? _mom] = ds_list_create();
					_list = tlmap[? _mom];
				}
				ds_list_add(_list, _data[i]);
			}
	
			timeline_clear(tl);
			timelineMarkers = array_create(ds_list_size(_markerList),-1);
			for(var i=0;i<ds_list_size(_markerList);i++) { 
				// create an array used for drawing the timeline to the UI
				timelineMarkers[i] = _markerList[| i];
				// add moment to the timeline
				timeline_moment_add_script(tl, _markerList[| i],TimelineSpawn);
			}
			ds_list_destroy(_markerList);
		} else {
			show_debug_message("ERROR timelinesetdata: stageData is undefined");
		}
	}
}

// timeline moment function
function TimelineSpawn(){
	var _list, _group, _stats;

	with(global.iGame)
	{
		_list = tlmap[? timeline_position];
		if(ds_list_size(_list) > 0)
		{
			for(var i=0;i<ds_list_size(_list);i++)
			{
				_group = _list[| i];
				if(!is_undefined(_group))
				{
					// get values to spawn the group
					_stats = defaultStats[? arrEnemies[_group.type]];
					_stats.path = _group.path;

					// spawn the group
					repeat(_group.groupSize){
						instance_create_layer(0, 0, "Instances", arrEnemies[_group.type], _stats);
					}
				}
			}
		} else {
			show_debug_message("ERROR at timelinespawn: list size is zero" );
		}
		
		if(timeline_position == timelineMarkers[array_length(timelineMarkers)-1])
		{
			timeline_running = false;
		}
	}
}