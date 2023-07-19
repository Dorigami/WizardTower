{
  "resourceType": "GMRoom",
  "resourceVersion": "1.0",
  "name": "rTest",
  "creationCodeFile": "${project_dir}/rooms/rTest/RoomCreationCode.gml",
  "inheritCode": false,
  "inheritCreationOrder": false,
  "inheritLayers": false,
  "instanceCreationOrder": [
    {"name":"inst_2B7245D5","path":"rooms/rTest/rTest.yy",},
    {"name":"inst_5BF496CB","path":"rooms/rTest/rTest.yy",},
  ],
  "isDnd": false,
  "layers": [
    {"resourceType":"GMRPathLayer","resourceVersion":"1.0","name":"Path_1","colour":4278190335,"depth":0,"effectEnabled":true,"effectType":null,"gridX":16,"gridY":16,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"pathId":{"name":"pathMob0","path":"paths/pathMob0/pathMob0.yy",},"properties":[],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"PlaySpace","depth":100,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_2B7245D5","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"oPlaySpace","path":"objects/oPlaySpace/oPlaySpace.yy",},"properties":[],"rotation":0.0,"scaleX":20.0,"scaleY":12.0,"x":32.0,"y":32.0,},
      ],"layers":[],"properties":[],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Instances","depth":200,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_5BF496CB","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"oMinimap","path":"objects/oMinimap/oMinimap.yy",},"properties":[],"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"x":416.0,"y":256.0,},
      ],"layers":[],"properties":[],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"ButtonSpace","depth":300,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"properties":[],"tiles":{"SerialiseHeight":14,"SerialiseWidth":22,"TileCompressedData":[
-243,-2147483648,-20,1,-2,-2147483648,-20,1,-23,-2147483648,],"TileDataFormat":1,},"tilesetId":{"name":"tsCol","path":"tilesets/tsCol/tsCol.yy",},"userdefinedDepth":false,"visible":true,"x":0,"y":0,},
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"Col","depth":400,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"properties":[],"tiles":{"SerialiseHeight":14,"SerialiseWidth":22,"TileCompressedData":[
-20,0,-2,-2147483648,1,0,-20,1,2,-2147483648,0,-20,1,2,-2147483648,0,-20,1,2,-2147483648,0,-15,
1,-4,0,-3,-2147483648,1,0,-19,1,1,-2147483648,-6,0,-16,-2147483648,-20,0,-2,-2147483648,1,0,-20,
1,2,-2147483648,0,-20,1,2,-2147483648,0,-20,1,2,-2147483648,0,-9,1,-10,0,-4,-2147483648,-8,1,
-3,-2147483648,-2,0,-29,-2147483648,],"TileDataFormat":1,},"tilesetId":{"name":"tsCol","path":"tilesets/tsCol/tsCol.yy",},"userdefinedDepth":false,"visible":false,"x":0,"y":0,},
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"TerrainTop","depth":500,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"properties":[],"tiles":{"SerialiseHeight":14,"SerialiseWidth":22,"TileCompressedData":[
-21,0,3,-2147483648,0,3,-14,0,1,1,-4,2,3,-2147483648,0,15,-14,0,1,13,-4,0,
3,-2147483648,0,15,-14,0,1,13,-4,0,3,-2147483648,0,15,-14,0,1,25,-4,26,3,-2147483648,
0,27,-19,0,1,-2147483648,-21,0,1,-2147483648,-21,0,3,-2147483648,0,3,-19,0,3,-2147483648,0,15,
-19,0,3,-2147483648,0,15,-19,0,3,-2147483648,0,15,-8,0,1,62,-10,63,3,-2147483648,0,27,
-8,0,1,74,-10,75,-23,-2147483648,],"TileDataFormat":1,},"tilesetId":{"name":"tsTerrain","path":"tilesets/tsTerrain/tsTerrain.yy",},"userdefinedDepth":false,"visible":true,"x":0,"y":0,},
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"TerrainBot","depth":600,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"properties":[],"tiles":{"SerialiseHeight":14,"SerialiseWidth":22,"TileCompressedData":[
-20,0,-2,-2147483648,1,0,-20,38,2,-2147483648,0,-20,38,2,-2147483648,0,-20,38,2,-2147483648,0,-20,
38,2,-2147483648,0,-20,38,3,-2147483648,0,65,-18,66,4,67,-2147483648,0,89,-18,90,3,91,-2147483648,
0,-20,38,2,-2147483648,0,-20,38,2,-2147483648,0,-20,38,2,-2147483648,0,-20,38,-2,-2147483648,-20,38,
-23,-2147483648,],"TileDataFormat":1,},"tilesetId":{"name":"tsTerrain","path":"tilesets/tsTerrain/tsTerrain.yy",},"userdefinedDepth":false,"visible":true,"x":0,"y":0,},
    {"resourceType":"GMRBackgroundLayer","resourceVersion":"1.0","name":"Background","animationFPS":15.0,"animationSpeedType":0,"colour":4282723085,"depth":700,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"hspeed":0.0,"htiled":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"properties":[],"spriteId":null,"stretch":false,"userdefinedAnimFPS":false,"userdefinedDepth":false,"visible":true,"vspeed":0.0,"vtiled":false,"x":0,"y":0,},
  ],
  "parent": {
    "name": "Rooms",
    "path": "folders/Rooms.yy",
  },
  "parentRoom": null,
  "physicsSettings": {
    "inheritPhysicsSettings": false,
    "PhysicsWorld": false,
    "PhysicsWorldGravityX": 0.0,
    "PhysicsWorldGravityY": 10.0,
    "PhysicsWorldPixToMetres": 0.1,
  },
  "roomSettings": {
    "Height": 448,
    "inheritRoomSettings": false,
    "persistent": false,
    "Width": 704,
  },
  "sequenceId": null,
  "views": [
    {"hborder":32,"hport":192,"hspeed":-1,"hview":192,"inherit":false,"objectId":null,"vborder":32,"visible":true,"vspeed":-1,"wport":320,"wview":320,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
  ],
  "viewSettings": {
    "clearDisplayBuffer": true,
    "clearViewBackground": false,
    "enableViews": true,
    "inheritViewSettings": false,
  },
  "volume": 1.0,
}