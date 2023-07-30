/// @description 


mouse_vect[1] = device_mouse_x_to_gui(0)-ox;
mouse_vect[2] = device_mouse_y_to_gui(0)-oy;

component_vect = vect_proj(mouse_vect, main_vect);

main_vect[1] = 80;
main_vect[2] = 0;
if(vect_dot(vect_norm(mouse_vect), vect_norm(main_vect)) > 0)
{
	mouse_vect = vect_subtract(mouse_vect , component_vect);
}


position[1] = mouse_x;
position[2] = mouse_y;

with(instance_place(x,y,oTestCollision0))
{
	EnforceMinDistance(oTestCollision0);
}

x = position[1];
y = position[2];
