function ControlSchemeDefault(){
	inpSelectionClear = keyboard_check_pressed(vk_space)
	inpMoveCommand = mouse_check_button_released(mb_right);
	inpUp = keyboard_check(ord("W"));
	inpLeft = keyboard_check(ord("A"));
	inpDown = keyboard_check(ord("S"));
	inpRight = keyboard_check(ord("D"));
	inpFastPan = keyboard_check(vk_shift);
	// unit selection
	if(mouse_check_button_released(mb_left)) clickPos = -1;
	if(mouse_check_button_pressed(mb_left)) 
	{
		clickPos = vect2(mouse_x, mouse_y);
		instance_create_layer(clickPos[1],clickPos[2],"Instances",oSelect);
	}
}
function ControlSchemeStructurePlacement(){
	inpSelectionClear = keyboard_check_pressed(vk_space)
	inpMoveCommand = mouse_check_button_released(mb_right);
	inpUp = keyboard_check(ord("W"));
	inpLeft = keyboard_check(ord("A"));
	inpDown = keyboard_check(ord("S"));
	inpRight = keyboard_check(ord("D"));
	inpFastPan = keyboard_check(vk_shift);
	// unit selection
	if(mouse_check_button_released(mb_left)) clickPos = -1;
	if(mouse_check_button_pressed(mb_left)) 
	{
		clickPos = vect2(mouse_x, mouse_y);
		instance_create_layer(clickPos[1],clickPos[2],"Instances",oSelect);
	}
}