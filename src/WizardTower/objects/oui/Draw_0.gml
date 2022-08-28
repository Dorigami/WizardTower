/// @description 

draw_set_alpha(image_alpha);
draw_set_font(fText);
// Inherit the parent event
event_inherited();

draw_set_alpha(image_alpha);
var _x = x + 20;
var _y = y + 20;
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(fTextSmall);


// health bar
var _hp = string(global.iGame.playerHealth);
var _money = string(global.iGame.playerMoney);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(_x,_y,"HEALTH: " + _hp + 
                      "\nMONEY: " + _money  
					  );
					  
draw_set_alpha(1);

if(global.gamePaused)
{
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	_x = x + 0.5*viewWidthHalf;
	_y = y + 0.3*viewHeightHalf;
	draw_text(_x,_y,"GAME PAUSED");
	draw_set_halign(fa_left);
	draw_set_valign(fa_bottom);
}
