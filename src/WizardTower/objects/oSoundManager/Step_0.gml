/// @description 

// play sounds that have been sent in
var _size = ds_queue_size(sound_queue);
var _gain = 1;
while(_size > 0)
{
	// only process a maximum of 3 sound commands per step
	repeat(min(_size, 3))
	{
		var _snd = ds_queue_dequeue(sound_queue);
	
		_size--;
		
		switch(_snd.type)
		{
			case GameMusic:
				show_debug_message("game music given");
				if(!music_load) 
				{
					// put sound back into queue
					ds_queue_enqueue(_snd);
				} else {
					music_fade_prev_song = music_fade_next_song;
					music_fade_next_song = _snd.value;
					music_fade = !audio_is_playing(music_fade_prev_song);
				}
				break;
				
			case SoundEffects:
				show_debug_message("sound effect given");
				if(!sndfx_load) 
				{
					// put sound back into queue
					ds_queue_enqueue(_snd);
				} else {
					_gain = sndfx_gain;	
					if(audio_is_playing(_snd.value)) _gain *= 0.5;
					audio_play_sound(_snd.value, 1, false, _gain);
				}
				break;
			case HUDEffects:
				show_debug_message("hud effect given");
				if(!hudfx_load) 
				{
					// put sound back into queue
					ds_queue_enqueue(_snd);
				} else {
					_gain = hudfx_gain;
					if(audio_is_playing(_snd.value)) _gain *= 0.5;
					audio_play_sound(_snd.value, 1, false, _gain);
				}
				break;
		}
		
		show_debug_message("playing sound: {0}", audio_get_name(_snd.value));
		
	}
}

// do fade transitions for music
if(music_fade != NONE)
{
	if(music_fade == IN)
	{
		_gain = audio_sound_get_gain(music_fade_next_song);
		show_debug_message("fading in");
		if(!audio_is_playing(music_fade_next_song)) 
		{
			audio_play_sound(music_fade_next_song, 1000, true, 0);
			audio_sound_gain(music_fade_next_song, music_gain, music_fade_duration);
			show_debug_message("done fading");
		}
		
		if(_gain >= music_gain)	music_fade = NONE;
		
	} else if(music_fade == OUT) {
		_gain = audio_sound_get_gain(music_fade_prev_song);
		if(_gain == 0){
			music_fade = audio_exists(music_fade_next_song);
		} else if(_gain =){
		}
		show_debug_message("fading out")
		// stop current song and start the next song
		if(audio_is_playing(music_fade_prev_song)) audio_stop_sound(music_fade_prev_song);
		audio_play_sound(music_fade_next_song, 1, true, _gain);
		audio_group_set_gain(GameMusic, music_gain, music_fade_duration)
		music_fade = IN;
	}
}


