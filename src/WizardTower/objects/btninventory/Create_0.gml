/// @description 
function GoToInventory(){
	show_debug_message("");
	room_goto(rMapGenTest);
}
// Inherit the parent event
event_inherited();

text = "Map \nGenerator";
gui = false;
leftScript = GoToInventory;
leftArgs = -1;
rightScript = GoToInventory;
rightArgs = -1;