/// @description 

// widget functions
{
	function IncrementMarchers(_cnt, _pow){
		with(container){
			marcher_count = clamp(marcher_count + _cnt, 0, 50);
			marcher_power = clamp(marcher_power + _pow, 1, 50);
			controlsList[| controlsMap[? "Mc"]].text = "CNT = " + string(marcher_count);
			controlsList[| controlsMap[? "Mp"]].text = "POW = " + string(marcher_power);
		}
	}
	function IncrementSwarmers(_cnt, _pow){
		with(container){
			swarmer_count = clamp(swarmer_count + _cnt, 0, 50);
			swarmer_power = clamp(swarmer_power + _pow, 1, 50);
			controlsList[| controlsMap[? "Sc"]].text = "CNT = " + string(swarmer_count);
			controlsList[| controlsMap[? "Sp"]].text = "POW = " + string(swarmer_power);
		}
	}
	function IncrementBuildingKillers(_cnt, _pow){
		with(container){
			bldkiller_count = clamp(bldkiller_count + _cnt, 0, 50);
			bldkiller_power = clamp(bldkiller_power + _pow, 1, 50);
			controlsList[| controlsMap[? "Bc"]].text = "CNT = " + string(bldkiller_count);
			controlsList[| controlsMap[? "Bp"]].text = "POW = " + string(bldkiller_power);
		}
	}
	function IncrementUnitKillers(_cnt, _pow){
		with(container){
			unitkiller_count = clamp(unitkiller_count + _cnt, 0, 50);
			unitkiller_power = clamp(unitkiller_power + _pow, 1, 50);
			controlsList[| controlsMap[? "Uc"]].text = "CNT = " + string(unitkiller_count);
			controlsList[| controlsMap[? "Up"]].text = "POW = " + string(unitkiller_power);
		}
	}
	function IncrementGoliaths(_cnt, _pow){
		with(container){
			goliath_count = clamp(goliath_count + _cnt, 0, 50);
			goliath_power = clamp(goliath_power + _pow, 1, 50);
			controlsList[| controlsMap[? "Gc"]].text = "CNT = " + string(goliath_count);
			controlsList[| controlsMap[? "Gp"]].text = "POW = " + string(goliath_power);
		}
	}
	function SpawnCustomWave(){
		with(container){
			var _x = global.game_grid_xorigin + global.game_grid_width*GRID_SIZE;
			var _y = global.game_grid_yorigin + global.game_grid_height*GRID_SIZE*random_range(0.05,0.95);
			var _cnt = 0, _pow = 0;
			var type_strings = ["marcher", "swarmer","buildingkiller","unitkiller","goliath"];
			var _fighterstats = undefined;
			// make the marchers
			for(var i=0;i<5;i++)
			{
				switch(type_strings[i])
				{
					case "marcher":
						_cnt = marcher_count;
						_pow = marcher_power;
						repeat(_cnt){
						with(ConstructUnit(_x,_y,ENEMY_FACTION,type_strings[i])){
							supply_cost = 2;
						    material_cost = 20;
							material_reward = 100;
						    experience_reward = 100;
							upgrade_reward = 100;
						    hp = 8;
						    strength = _pow;
						    defense = 1;
						    speed = 2;
						    range = 5;
						}}
					break;
					case "swarmer":
						_cnt = swarmer_count;
						_pow = swarmer_power;
						repeat(_cnt){
						with(ConstructUnit(_x,_y,ENEMY_FACTION,type_strings[i])){
							supply_cost = 2;
						    material_cost = 20;
							material_reward = 100;
						    experience_reward = 100;
							upgrade_reward = 100;
						    hp = 8;
						    strength = _pow;
						    defense = 1;
						    speed = 2;
						    range = 5;
						}}
					break;
					case "buildingkiller":
						_cnt = bldkiller_count;
						_pow = bldkiller_power;
						repeat(_cnt){
						with(ConstructUnit(_x,_y,ENEMY_FACTION,type_strings[i])){
							supply_cost = 2;
						    material_cost = 20;
							material_reward = 100;
						    experience_reward = 100;
							upgrade_reward = 100;
						    hp = 8;
						    strength = _pow;
						    defense = 1;
						    speed = 2;
						    range = 5;
						}}
					break;
					case "unitkiller":
						_cnt = unitkiller_count;
						_pow = unitkiller_power;
						repeat(_cnt){
						with(ConstructUnit(_x,_y,ENEMY_FACTION,type_strings[i])){
							supply_cost = 2;
						    material_cost = 20;
							material_reward = 100;
						    experience_reward = 100;
							upgrade_reward = 100;
						    hp = 8;
						    strength = _pow;
						    defense = 1;
						    speed = 2;
						    range = 5;
						}}
					break;
					case "goliath":
						_cnt = goliath_count;
						_pow = goliath_power;
						repeat(_cnt){
						with(ConstructUnit(_x,_y,ENEMY_FACTION,type_strings[i])){
							supply_cost = 2;
						    material_cost = 20;
							material_reward = 100;
						    experience_reward = 100;
							upgrade_reward = 100;
						    hp = 8;
						    strength = _pow;
						    defense = 1;
						    speed = 2;
						    range = 5;
						}}
					break;
				}

			}
		}
	}
}


// Inherit the parent event
event_inherited();

// tab stuff
tab_hgt = 20;
tab_wdt = 300;
tab_bbox = [0,0,tab_wdt,tab_hgt];
on_tab = false;
dragging = [false,0,0];

// wave data
marcher_count = 0;
marcher_power = 1;
swarmer_count = 0;
swarmer_power = 1;
bldkiller_count = 0;
bldkiller_power = 1;
unitkiller_count = 0;
unitkiller_power = 1;
goliath_count = 0;
goliath_power = 1;

widget_names = ["Marchers","Swarmers","BLD Killers","Unit Killers","Goliaths"];
var origin = [0,0];
wdt = tab_wdt;
hgt = 50;
for(var i = 0; i < array_length(widget_names); i++)
{
	switch(widget_names[i]){
	case "Marchers":
		// name
		LabelAdd(origin[0], origin[1]+24,id,ds_list_size(controlsList),"M",undefined,widget_names[i]);
		//count
		LabelAdd(origin[0]+100, origin[1]+30,id,ds_list_size(controlsList),"Mc",undefined,"CNT = " + string(marcher_count));
		ButtonAdd(origin[0]+126, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"McInc",sBtn24x24,undefined,"+",undefined,IncrementMarchers,[1,0]);
		ButtonAdd(origin[0]+100, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"McDec",sBtn24x24,undefined,"-",undefined,IncrementMarchers,[-1,0]);
		// power
		LabelAdd(origin[0]+200, origin[1]+30,id,ds_list_size(controlsList),"Mp",undefined,"POW = " + string(marcher_power));
		ButtonAdd(origin[0]+226, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"MpInc",sBtn24x24,undefined,"+",undefined,IncrementMarchers,[0,1]);
		ButtonAdd(origin[0]+200, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"MpDec",sBtn24x24,undefined,"-",undefined,IncrementMarchers,[0,-1]);
	break;
	case "Swarmers":
		// name
		LabelAdd(origin[0],origin[1]+24,id,ds_list_size(controlsList),"S",undefined,widget_names[i]);
		//count
		LabelAdd(origin[0]+100, origin[1]+30,id,ds_list_size(controlsList),"Sc",undefined,"CNT = " + string(swarmer_count));
		ButtonAdd(origin[0]+126, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"ScInc",sBtn24x24,undefined,"+",undefined,IncrementSwarmers,[1,0]);
		ButtonAdd(origin[0]+100, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"ScDec",sBtn24x24,undefined,"-",undefined,IncrementSwarmers,[-1,0]);
		// power
		LabelAdd(origin[0]+200, origin[1]+30,id,ds_list_size(controlsList),"Sp",undefined,"POW = " + string(swarmer_power));
		ButtonAdd(origin[0]+226, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"SpInc",sBtn24x24,undefined,"+",undefined,IncrementSwarmers,[0,1]);
		ButtonAdd(origin[0]+200, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"SpDec",sBtn24x24,undefined,"-",undefined,IncrementSwarmers,[0,-1]);
	break;
	case "BLD Killers":
		// name
		LabelAdd(origin[0],origin[1]+24,id,ds_list_size(controlsList),"B",undefined,widget_names[i]);
		//count
		LabelAdd(origin[0]+100, origin[1]+30,id,ds_list_size(controlsList),"Bc",undefined,"CNT = " + string(bldkiller_count));
		ButtonAdd(origin[0]+126, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"BcInc",sBtn24x24,undefined,"+",undefined,IncrementBuildingKillers,[1,0]);
		ButtonAdd(origin[0]+100, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"BcDec",sBtn24x24,undefined,"-",undefined,IncrementBuildingKillers,[-1,0]);
		// power
		LabelAdd(origin[0]+200, origin[1]+30,id,ds_list_size(controlsList),"Bp",undefined,"POW = " + string(bldkiller_power));
		ButtonAdd(origin[0]+226, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"BpInc",sBtn24x24,undefined,"+",undefined,IncrementBuildingKillers,[0,1]);
		ButtonAdd(origin[0]+200, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"BpDec",sBtn24x24,undefined,"-",undefined,IncrementBuildingKillers,[0,-1]);
	break;
	case "Unit Killers":
		// name
		LabelAdd(origin[0],origin[1]+24,id,ds_list_size(controlsList),"U",undefined,widget_names[i]);
		//count
		LabelAdd(origin[0]+100, origin[1]+30,id,ds_list_size(controlsList),"Uc",undefined,"CNT = " + string(unitkiller_count));
		ButtonAdd(origin[0]+126, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"UcInc",sBtn24x24,undefined,"+",undefined,IncrementUnitKillers,[1,0]);
		ButtonAdd(origin[0]+100, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"UcDec",sBtn24x24,undefined,"-",undefined,IncrementUnitKillers,[-1,0]);
		// power
		LabelAdd(origin[0]+200, origin[1]+30,id,ds_list_size(controlsList),"Up",undefined,"POW = " + string(unitkiller_power));
		ButtonAdd(origin[0]+226, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"UpInc",sBtn24x24,undefined,"+",undefined,IncrementUnitKillers,[0,1]);
		ButtonAdd(origin[0]+200, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"UpDec",sBtn24x24,undefined,"-",undefined,IncrementUnitKillers,[0,-1]);
	break;
	case "Goliaths":
		// name
		LabelAdd(origin[0],origin[1]+24,id,ds_list_size(controlsList),"G",undefined,widget_names[i]);
		//count
		LabelAdd(origin[0]+100, origin[1]+30,id,ds_list_size(controlsList),"Gc",undefined,"CNT = " + string(goliath_count));
		ButtonAdd(origin[0]+126, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"GcInc",sBtn24x24,undefined,"+",undefined,IncrementGoliaths,[1,0]);
		ButtonAdd(origin[0]+100, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"GcDec",sBtn24x24,undefined,"-",undefined,IncrementGoliaths,[-1,0]);
		// power
		LabelAdd(origin[0]+200, origin[1]+30,id,ds_list_size(controlsList),"Gp",undefined,"POW = " + string(goliath_power));
		ButtonAdd(origin[0]+226, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"GpInc",sBtn24x24,undefined,"+",undefined,IncrementGoliaths,[0,1]);
		ButtonAdd(origin[0]+200, origin[1]+3,id,ds_list_size(controlsList),widget_names[i]+"GpDec",sBtn24x24,undefined,"-",undefined,IncrementGoliaths,[0,-1]);
	break;
	}
	origin[1] += hgt;
}
ButtonAdd(origin[0]+0.15*wdt  ,origin[1]+0*hgt,id,ds_list_size(controlsList),"Spawn",sBtn174x24,undefined,"SPAWN WAVE",undefined,SpawnCustomWave,-1);

for(var i=0; i<ds_list_size(controlsList); i++)
{
	if(is_instanceof(controlsList[| i], Button))
	{
		controlsList[| i].color = c_black;
	}
}
