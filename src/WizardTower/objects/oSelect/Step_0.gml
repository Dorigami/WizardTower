/// @description Control Selection Painter

if(!enabled) exit;

len_ = point_distance(x,y,mouse_x,mouse_y);
dir_ = point_direction(x,y,mouse_x,mouse_y);

image_xscale = lengthdir_x(len_, dir_);
image_yscale = lengthdir_y(len_, dir_);

visible = len_ >= 30 ? true : false;
