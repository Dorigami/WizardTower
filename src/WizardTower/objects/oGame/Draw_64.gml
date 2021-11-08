/// @description view data
draw_set_alpha(1);
draw_set_font(fText);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(5,5,room_get_name(room));
/*

draw_set_alpha(1);
draw_set_font(fText);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(10,10,
	string(current_time)
	+"\nApplication Surface: [ W:"+string(surface_get_width(application_surface))+" H:"+string(surface_get_height(application_surface))+"]"
	+"\nWindow: [ W:"+string(window_get_width())+" H:"+string(window_get_height())+" ]"
	+"\nGUI: [ W:"+string(display_get_gui_width())+" H:"+string(display_get_gui_height())+" ]"
	+"\nPORT: [ X:"+string(view_get_xport(view_camera[0]))+" Y:"+string(view_get_yport(view_camera[0]))+" ] "+" [ W:"+string(view_get_wport(view_camera[0]))+" H:"+string(view_get_hport(view_camera[0]))+" ]"
	+"\nVIEW: [ X:"+string(camera_get_view_x(view_camera[0]))+" Y:"+string(camera_get_view_y(view_camera[0]))+" ] "+" [ W:"+string(camera_get_view_width(view_camera[0]))+" H:"+string(camera_get_view_height(view_camera[0]))+" ]"
);
draw_text(device_mouse_x_to_gui(0),device_mouse_y_to_gui(0),"["+string(mouse_x)+" "+string(mouse_y)+"]");