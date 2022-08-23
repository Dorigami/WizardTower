/// @description draw UI

/*

var _width = camera_get_view_width(view_camera[0]);
var _height = camera_get_view_height(view_camera[0]);
if(global.showMenu)
{
	draw_set_color(c_black);
	draw_set_alpha(0.3);
	draw_rectangle(0,0,_width,_height,false);
	draw_set_color(c_white);
	draw_set_alpha(1);
	if(instance_exists(oPlayer))
	{
		var _stats = global.playerStats;
		var _str = "";
		_str = "LEVEL: " + string(global.playerLevel);
		_str += "\nEXP: " + string(global.playerExperience) + " / " + string(global.playerExperienceNextLevel);
		_str += "\nHEALTH: " + string(_stats[STATBLOCK.HEALTH]) + " / " + string(_stats[STATBLOCK.HEALTHMAX]);
		_str += "\nSTRENGTH: " + string(_stats[STATBLOCK.STRENGTH]);
		_str += "\nDEXTERITY: " + string(_stats[STATBLOCK.DEXTERITY]);
		_str += "\nARMOR: " + string(_stats[STATBLOCK.ARMOR]);
		_str += "\nSPEED: " + string(_stats[STATBLOCK.SPEED]);
		_str += "\nMONEY: " + string(global.playerMoney);
		_str += "\nACTION: " + string(global.playerAction);
		_str += "\nSTATE: " + script_get_name(oPlayer.state);
		DrawTextParameters(fTextSmall,fa_left,fa_top,c_white,1);
		draw_text_ext(camera_get_view_width(view_camera[0])-210, 40, _str,10,500);
	}
}
// Current Floor in the dungeon
DrawTextParameters(fText,fa_center,fa_top,c_white,1);
draw_text(0.5*camera_get_view_width(view_camera[0]),2, "FLOOR: " + string(global.dungeonFloor));
//Narrator Log
var _sep = 8;

DrawTextParameters(fTextNarrator,fa_left,fa_top,c_white,1);
draw_text_ext(0.05*camera_get_view_width(view_camera[0]),camera_get_view_height(view_camera[0])-40, fullLog, _sep, 0.45*_width);
draw_set_alpha(1);

/*

// HEALTH
var _playerHealth = global.playerHealth;
var _playerHealthMax = global.playerHealthMax;
var _playerHealthFrac = frac(_playerHealth);
_playerHealth -= _playerHealthFrac;

for(var i=1; i<=_playerHealthMax; i++)
{
	// full or empty heart
	var _imageIndex = (i > _playerHealth);
	// partial heart
	if(i == _playerHealth+1)
	{
		_imageIndex += (_playerHealthFrac > 0);
		_imageIndex += (_playerHealthFrac > 0.25);
		_imageIndex += (_playerHealthFrac > 0.5);
	}
	draw_sprite(sHealth,_imageIndex,8+((i-1)*16),8);
}

// MONEY
var _xx, _yy;

_xx = 28;
_yy = 31;
draw_sprite(sCoinUI,8,_xx,_yy);

draw_set_color(c_black);
draw_set_font(fText);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
_xx += sprite_get_width(sCoinUI) + 4;
_yy = 27;
var _str = string(global.playerMoney)
draw_text(_xx+1, _yy, _str);
draw_text(_xx-1, _yy, _str);
draw_text(_xx, _yy+1, _str);
draw_text(_xx, _yy-1, _str);
draw_set_color(c_white);
draw_text(_xx, _yy, _str);


// ITEM BOX\
_xx = 8;
_yy = 24;
draw_sprite(sItemUIBox, 0, _xx, _yy);
if(global.playerHasAnyItems)
{
	draw_sprite(sItemUI, global.playerEquipped, _xx, _yy)
	if(global.playerAmmo[global.playerEquipped] != -1)
	{
		draw_set_font(fAmmo);
		draw_set_halign(fa_right);
		draw_set_valign(fa_bottom);
		draw_set_color(c_white);
		draw_text(
			_xx + sprite_get_width(sItemUIBox)+1,
			_yy + sprite_get_height(sItemUIBox)+1,
			string(global.playerAmmo[global.playerEquipped])
		);
	}
}
