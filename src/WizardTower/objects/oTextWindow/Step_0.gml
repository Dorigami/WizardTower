/// @description 

// fade out when target is lost
if(target == noone)
{
	// fade out and destroy
	alpha_ = max(0, alpha_ - 0.05);
	image_alpha = alpha_;
	if(alpha_ == 0) 
	{
		instance_destroy(); 
	}
	exit; // don't run anything else while fading out
} 

// ignore the GUI Controller
if(!target.text_window_enabled) exit;

// set position
x = device_mouse_x_to_gui(0);
y = device_mouse_y_to_gui(0);

if(!is_instanceof(ability, global.iEngine.Ability)) 
{
	if(target != noone) show_debug_message("text window created with no ABILITY to reference");
	instance_destroy();
}
// update strings from the target
if(update_ability)
{
	update_ability = false;
	
	title_ = ability.title;
	description_ = ability.description;
	values_ = ability.values;
	values_names_ = variable_struct_get_names(values_);
	
	title_height_ = 20;
	description_height_ = string_height_ext(description_, 3+string_height("I"), width_-20) + 10;
	values_height_ = ((array_length(values_names_)+1) * 20) + 2 ;
	height_ = title_height_ + description_height_ + values_height_;
}

// fade in
alpha_ = min(alpha_+0.05, 1);
image_alpha = alpha_;

// calculate the border locations
b_left = min(x,x+sign(halign)*width_);
b_top = min(y,y+sign(valign)*height_);
b_right = max(x,x+sign(halign)*width_);
b_bottom = max(y,y+sign(valign)*height_);


//--// KEEP WINDOW ON SCREEN
if(valign == 1)
{
	if(b_bottom > display_get_gui_height()) { valign = -1 }
} else {
	if(b_top < 0) { valign = 1 }
}
if(halign == 1)
{
	if(b_right > display_get_gui_width()) { halign = -1 }
} else {
	if(b_left < 0) { halign = 1 }
}

// check if mouse is still on target
with(target)
{
	if(!focus) 
	{
		show_debug_message("clearing target")
		other.target = noone;
	}
	// if(!point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0),bbox_left,bbox_top,bbox_right,bbox_bottom)) other.target = noone;
}

// show the window
if(!visible) visible = true;



