/// @description 

draw_set_alpha(image_alpha);
draw_set_font(fText);
// Inherit the parent event
event_inherited();

var _x = x + 1.6*viewWidthHalf;
var _y = y + 1.8*viewHeightHalf;
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_set_font(fTextSmall);
draw_text_ext(_x,_y,fullLog, 14, 140);

// health bar
var _hp = string(global.iPlayer.hp);
var _hpMax = string(global.iPlayer.Health);
var _xp = string(global.iPlayer.xp);
var _xpMax = string(global.iPlayer.xpToNextLevel);
var _lvl = string(global.iPlayer.Level);
var _pts = string(global.iPlayer.LevelUpPoints); 
var _coins = string(global.iPlayer.coins);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text(x+160,y+280,"HP: " + _hp + " / " + _hpMax + 
                      "\nXP: " + _xp + " / " + _xpMax + 
					  "\nLevel: " + _lvl +
					  "\nLevel Points: " + _pts +
					  "\nCoins: " + _coins
					  );

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
