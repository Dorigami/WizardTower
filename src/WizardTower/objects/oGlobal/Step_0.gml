/// @description 

if(keyboard_check_pressed(vk_f1)) && (room != rContextSteering) room_goto(rContextSteering);
if(keyboard_check_pressed(vk_f2)) && (room != rCrowdSteering) room_goto(rCrowdSteering);
if(keyboard_check_pressed(vk_f3)) && (room != rBoids) room_goto(rBoids);


