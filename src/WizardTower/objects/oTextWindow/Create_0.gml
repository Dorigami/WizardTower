/// @description initialize

show_debug_message("text window create");

// get a target
// target = collision_point(device_mouse_x_to_gui(0),device_mouse_y_to_gui(0),par_gui_button,false,true);
// if(target == noone) target = collision_point(device_mouse_x_to_gui(0),device_mouse_y_to_gui(0),par_button,false,true);

alpha_ = 0;
//title_ = "";
//description_ = "";
//values_ = undefined;
values_names_ = undefined;
width_ = 120;
height_ = 10;

halign = -1; // says which side of the mouse to draw the window
valign = 1; // says which side of the mouse to draw the window
b_left = 0;
b_right = 0;
b_top = 0;
b_bottom = 0;

// heights of each section
title_height_ = 0;
description_height_ = 0;
values_height_ = 0;

update_ability = true;

