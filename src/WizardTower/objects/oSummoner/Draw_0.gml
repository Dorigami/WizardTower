/// @description 

// Inherit the parent event
event_inherited();

if(is_undefined(unit)) exit;

if(unit.blueprint_instance != noone)
{
	var _str = "blueprint instance = " + string(unit.blueprint_instance) 
			 + "\ncommand = " string(ai.command); 
	draw_set_halign(fa_left);
	draw_text(x,y+20,_str);
}