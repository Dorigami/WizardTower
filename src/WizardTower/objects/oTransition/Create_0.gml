/// @description enums and setup
depth = -9999;
enum TRANS_TYPE
{
	SLIDE,
	FADE,
	PUSH,
	STAR,
	WIPE
}


width = display_get_gui_width(); // RESOLUTION_W;
height = display_get_gui_height(); // RESOLUTION_H;
heightHalf = 0.5*height + 20;
percent = 0;
leading = OUT;
transitionScript = -1;
transitionSpeed = 0.02;