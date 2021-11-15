function HurtEntity(_source,_target,_damage){
	with(_target)
	{
		if(state != STATE.DEAD)
		{
			// deal damage
			hp -= _damage;
			// cause a flash
			flash = 1;
			
			//hurt or dead
			if(hp <= 0)
			{
				state = STATE.DEAD;
				image_index = 0;
			} 
			//// play sound
			//if(!global.sfxMute)
			//{
			//	if(audio_is_playing(sndEnemyHurt)) audio_stop_sound(sndEnemyHurt);
			//	audio_sound_gain(sndEnemyHurt,global.sfxVolume,0);
			//	audio_play_sound(sndEnemyHurt,10,false);
			//}
		}
	}
}