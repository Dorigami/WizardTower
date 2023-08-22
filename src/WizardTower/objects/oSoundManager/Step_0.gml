/// @description 

// play sounds that have been sent in
var _size = ds_queue_size(sound_queue);
var _gain = 1;
if(_size > 0)
{
	// only process a maximum of 3 sound commands per step
	repeat(min(_size, 3))
	{
		var _snd = ds_queue_dequeue(sound_queue);
	
		_size--;
		
		switch(_snd.type)
		{
			case GameMusic:
				
				if(!music_load) 
				{
					// put sound back into queue
					ds_queue_enqueue(sound_queue,_snd);
					show_debug_message("re inserting music");
				} else {
					// set next song then set up to fade into it
					music_fade_next_song = _snd.value;
					music_fade_direction = !audio_is_playing(music_fade_prev_song);
					show_debug_message("game music given, fade state = {0}", music_fade_direction);
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
var _g1 = audio_exists(music_fade_prev_song) ? audio_sound_get_gain(music_fade_prev_song) : -1;
var _g2 = audio_exists(music_fade_next_song) ? audio_sound_get_gain(music_fade_next_song) : -1;
var _s1 = audio_exists(music_fade_prev_song) ? audio_get_name(music_fade_prev_song) : -1;
var _s2 = audio_exists(music_fade_next_song) ? audio_get_name(music_fade_next_song) : -1;
//show_debug_message("previous song(gain) = ({2}){0}  fade state = {4}\nnext song(gain) = ({3}){1}\n", 
//	_s1,_s2,_g1,_g2,music_fade_direction);

// do fade transitions for music
if(music_fade_direction != NONE)
{
	if(music_fade_direction == IN)
	{	
		// fade in the next song
	
		// play the song, if not already
		if(!audio_is_playing(music_fade_next_song)) 
		{
			music_fade = 0;
			audio_play_sound(music_fade_next_song, 1000, true);
			show_debug_message("starting song");
		} else {
			// set music gain level as it transitions
			music_fade = min(music_gain, music_fade+music_fade_rate);
			audio_sound_gain(music_fade_next_song, music_fade, 0);
		}
		

		show_debug_message("music fade_in | gain = {0}, song = {1}", _g2, _s2);
		// stop transitioning
		if(music_fade >= music_gain)	
		{
			music_fade_prev_song = music_fade_next_song;
			music_fade_next_song = -1;
			music_fade_direction = NONE;
		}
	} else {
		// fade out the current song
		music_fade = max(0, audio_sound_get_gain(music_fade_prev_song) - music_fade_rate);
		if(music_fade <= 0){
			if(audio_is_playing(music_fade_prev_song)) audio_stop_sound(music_fade_prev_song);
			if(music_fade_next_song != -1)
			{
				music_fade_direction = audio_exists(music_fade_next_song);
			} else {
				music_fade_direction = NONE;
			}
		} 
		show_debug_message("music fade_out | gain = {0}, song = {1}", _g1, _s1);
		audio_sound_gain(music_fade_prev_song, music_fade, 0);
	}
}


