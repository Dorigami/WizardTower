/// @description 


// Inherit the parent event
event_inherited();

width = 260;
height = 500;
mouseOffsetX = 0;
mouseOffsetY = 0;

x = 0;
y = 0;

tabHeight = 10; // thickness of the tab used to click and drag window
tabDrag = false;


// get all existing paths from the room's layer properties
varPaths = [];
for(var i=0;i<6;i++)
{
	if(path_get_closed(global.mobPaths[i]) == false) 
	{
		varPaths[array_length(varPaths)] = global.mobPaths[i];
		show_debug_message("adding path: " + path_get_name(global.mobPaths[i]));
	}
}
if(array_length(varPaths) > 0) path = varPaths[0];
show_debug_message(string(varPaths));

// list the names of the variables that will be adjusted
varNames = [
    "path",
    "type",
    "groupSize",
    "health",
    "speed",
    "armor",
    "stealth",
    "money"
];
varEnemies = [
    oImp
];

function SetPath(){ 
	with(container)
	{
	    var txtbox = controlsList[| controlsMap[? "path"]];
	    // set value
        if(txtbox.text != "")
        {
            path = varPaths[clamp(real(txtbox.text),0,array_length(varPaths)-1)];
            txtbox.text = "";
            txtbox.caption = "path = " + string(path) + " (" + path_get_name(path) + ")";
        }
	}
}
function SetType(){ 
	with(container)
	{
	    var txtbox = controlsList[| controlsMap[? "type"]];
	    // set value
        if(txtbox.text != "")
        {
            type = clamp(real(txtbox.text),0,array_length(varEnemies)-1);
            txtbox.text = "";
            txtbox.caption = "type = " + string(type) + " (" + object_get_name(varEnemies[type]) + ")";
        }
	}
}
function SetGroupSize(){
	with(container)
	{
	    var txtbox = controlsList[| controlsMap[? "groupSize"]];
	    // set value
        if(txtbox.text != "")
        {
            groupSize = real(txtbox.text);
            txtbox.text = "";
            txtbox.caption = "groupSize = " + string(groupSize);
        }
    }
}
function SetHealth(){
	with(container)
	{
	    var txtbox = controlsList[| controlsMap[? "health"]];
	    // set value
        if(txtbox.text != "")
        {
            hp = real(txtbox.text);
            txtbox.text = "";
            txtbox.caption = "health = " + string(hp);
        }
    }
}
function SetSpeed(){
	with(container)
	{
	    var txtbox = controlsList[| controlsMap[? "speed"]];
	    // set value
        if(txtbox.text != "")
        {
            spd = real(txtbox.text);
            txtbox.text = "";
            txtbox.caption = "speed = " + string(spd);
        }
	}
}
function SetArmor(){
	with(container)
	{
	    var txtbox = controlsList[| controlsMap[? "armor"]];
	    // set value
        if(txtbox.text != "")
        {
            armor = real(txtbox.text);
            txtbox.text = "";
            txtbox.caption = "armor = " + string(armor);
        }
	}
}
function SetStealth(){
	with(container)
	{
	    var txtbox = controlsList[| controlsMap[? "stealth"]];
	    // set value
        if(txtbox.text != "")
        {
            stealth = clamp(real(txtbox.text),0,1);
            txtbox.text = "";
            txtbox.caption = "stealth = " + string(stealth);
        }
	}
}
function SetMoney(){
	with(container)
	{
	    var txtbox = controlsList[| controlsMap[? "money"]];
	    // set value
        if(txtbox.text != "")
        {
            money = real(txtbox.text);
            txtbox.text = "";
            txtbox.caption = "money = " + string(money);
        }
	}
}
function SpawnMob(){
	with(container)
	{
	    var _struct = {
	        path : path,
	        hp : hp,
	        damage : damage,
	        spd : spd,
	        armor : armor,
	        stealth : stealth,
	        money : money   
	    };
	    // create the mob using the struct, and let it initialize itself
	    var _obj = varEnemies[type];
		repeat(groupSize){
			instance_create_layer(0, 0, "Instances", _obj, _struct);
		}
	}
}

var _sprite = sTextbox;
var _h1 = 110;
var _h2 = 215
var _vOrigin = 20;
var _vSpacing = 22;
var yValues = array_create(9, 0);
for(var i=0;i<9;i++) yValues[i] = _vOrigin+_vSpacing*i

TextBoxAdd(_h1,yValues[0],id,0,"path",_sprite,"","path = " + string(path),5,SetPath,-1);
TextBoxAdd(_h1,yValues[1],id,1,"type",_sprite,"","type = " + string(type),5,SetType,-1);
TextBoxAdd(_h1,yValues[2],id,2,"groupSize",_sprite,"","groupSize = " + string(groupSize),5,SetGroupSize,-1);
TextBoxAdd(_h1,yValues[3],id,3,"health",_sprite,"","health = " + string(hp),5,SetHealth,-1);
TextBoxAdd(_h1,yValues[4],id,4,"speed",_sprite,"","speed = " + string(spd),5,SetSpeed,-1);
TextBoxAdd(_h1,yValues[5],id,5,"armor",_sprite,"","armor = " + string(armor),5,SetArmor,-1);
TextBoxAdd(_h1,yValues[6],id,6,"stealth",_sprite,"","stealth = " + string(stealth),5,SetStealth,-1);
TextBoxAdd(_h1,yValues[7],id,7,"money",_sprite,"","money = " + string(money),5,SetMoney,-1);

_sprite = sBtnRadial16x16;
ButtonAdd(_h2,yValues[0],id,8,"btnPath",_sprite,-1,,,SetPath,-1);
ButtonAdd(_h2,yValues[1],id,9,"btnType",_sprite,-1,,,SetType,-1);
ButtonAdd(_h2,yValues[2],id,10,"btnGroupSize",_sprite,-1,,,SetGroupSize,-1);
ButtonAdd(_h2,yValues[3],id,11,"btnHealth",_sprite,-1,,,SetHealth,-1);
ButtonAdd(_h2,yValues[4],id,12,"btnSpeed",_sprite,-1,,,SetSpeed,-1);
ButtonAdd(_h2,yValues[5],id,13,"btnArmor",_sprite,-1,,,SetArmor,-1);
ButtonAdd(_h2,yValues[6],id,14,"btnStealth",_sprite,-1,,,SetStealth,-1);
ButtonAdd(_h2,yValues[7],id,15,"btnMoney",_sprite,-1,,,SetMoney,-1);

ButtonAdd(215,yValues[8],id,16,"btnSpawn",sBtnAction,-1,"spawn",vk_space,SpawnMob,-1);