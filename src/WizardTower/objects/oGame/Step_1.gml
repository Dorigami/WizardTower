/// @description active timers


// loop through list to increment timers (MOVE-BASED TIME)
if(global.playerMoveCounter != moveCountCheck)
{
	var _indOffset = 0;
	var _size = ds_list_size(nodeActiveTimers);
	var _diff = global.playerMoveCounter - moveCountCheck;
	moveCountCheck = global.playerMoveCounter;
	
	if(_size > 0) { for(var i=0; i<_size; i++)
	{
	    var _node = nodeActiveTimers[| i-_indOffset];
		_node.timer = max(_node.timer - _diff, 0);
	    var _trigger = (_node.timer == 0);
	    if(_trigger)
	    {
	        // set timer to -1 
	        _node.timer = -1;
	        // perform an action
	        switch(_node.state)
	        {
	            case NODE.SOLID:
	                _node.state = NODE.BROKEN;
	                _node.timer = _node.refreshTime;
	                break;
	            case NODE.SINGLESOLID:
	                _node.state = NODE.PBROKEN;
	                break;
	            case NODE.BROKEN:
	                _node.state = NODE.SOLID;
	                break;
	            default:
	                // do nothing
	                break;
	        }
			_node.SetTile();
	        // then remove from the active timers 
	        if(_node.timer == -1)
	        {
	            ds_list_delete(nodeActiveTimers, i-_indOffset);
	            _indOffset++;
	        }
	    }
	}}
}

/*

// loop through list to increment timers (REAL TIME)
var _size = ds_list_size(nodeActiveTimers);
var _indOffset = 0;
if(_size > 0) { for(var i=0; i<_size; i++)
{
    var _node = nodeActiveTimers[| i-_indOffset];
    var _trigger = (--_node.timer == 0);
    if(_trigger)
    {
        // set timer to -1 
        _node.timer = -1;
        // perform an action
        switch(_node.state)
        {
            case NODE.SOLID:
                _node.state = NODE.BROKEN;
                _node.timer = _node.refreshTime;
                break;
            case NODE.SINGLESOLID:
                _node.state = NODE.PBROKEN;
                break;
            case NODE.BROKEN:
                _node.state = NODE.SOLID;
                break;
            default:
                // do nothing
                break;
        }
		_node.SetTile();
        // then remove from the active timers 
        if(_node.timer == -1)
        {
            ds_list_delete(nodeActiveTimers, i-_indOffset);
            _indOffset++;
        }
    }
}}
