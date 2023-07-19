function InitializeDisplay(_asp){
	//// dynamic resolution
		//idealWidth = 0;
		//idealHeight = RESOLUTION_H;
		//aspect_ratio_ = display_get_width() / display_get_height();
		//idealWidth = round(idealHeight*aspect_ratio_);
	// static resolution
	show_debug_message("Initialize Display: asp ratio = {0}", _asp);
	aspect_ratio_ = _asp;
	idealWidth = RESOLUTION_W;
	idealHeight = round(idealWidth / _asp);
	

	// perfect pixel scaling
		if(display_get_width() mod idealWidth != 0)
		{
			var d = round(display_get_width() / idealWidth);
			idealWidth = display_get_width() / d;
		}
		if(display_get_height() mod idealHeight != 0)
		{
			var d = round(display_get_height() / idealHeight);
			idealHeight = display_get_height() / d;
		}

	//check for odd numbers
	if(idealWidth & 1) idealWidth++;
	if(idealHeight & 1) idealHeight++;

	//do the zoom
	zoom = 2; // 1, 2, or 3
	zoomMax = floor(display_get_width() / idealWidth);
	zoom = min(zoom, zoomMax);
	view_zoom = 1;
	
	// enable & set views of each room
	for(var i=0; i<=100; i++)
	{
		if(!room_exists(i)) break;
		show_debug_message(room_get_name(i)+" has been initialized")
		if(i == 30){show_message("update display initialize, there are too many rooms")}
		room_set_view_enabled(i, true);
		room_set_viewport(i,0,true,0,0,idealWidth, idealHeight);
		//room_set_camera(i,0,view_camera[0])
	}	
	surface_resize(application_surface, idealWidth, idealHeight);
	display_set_gui_size(idealWidth, idealHeight);
	window_set_size(idealWidth*zoom, idealHeight*zoom);
	alarm[0] = 1;
}