/// @description 
Pathfinding();


//room_width = GRID_WIDTH*CELL_SIZE;
//room_height = GRID_HEIGHT=CELL_SIZE;
global.speed = 1.5;
global.densityMax = 3000;
global.densityThresh = 300;
global.controller = id;

pathHeap = new NodeHeap();
pathQueue = ds_queue_create();


for(var i=0;i<GRID_WIDTH;i++)
{
for(var j=0;j<GRID_HEIGHT;j++)
{
    global.gridSpace[# i, j] = new GridNode(i ,j);
}
}



