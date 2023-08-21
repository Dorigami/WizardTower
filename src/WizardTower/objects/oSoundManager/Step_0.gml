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
				
				if(!music_load) 
				{
					// put sound back into queue
					ds_queue_enqueue(sound_queue,_snd);
					show_debug_message("re inserting music");
				} else {
					// set next song then set up to fade into it
					music_fade_next_song = _snd.value;
					music_fade = !audio_is_playing(music_fade_prev_song);
					show_debug_message("game music given, fade state = {0}", music_fade);
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
show_debug_message("previous song(gain) = ({2}){0}  fade state = {4}\nnext song(gain) = ({3}){1}/n\n", 
	music_fade_prev_song, 
	music_fade_next_song, 
	_g1, 
	_g2,
	music_fade);

// do fade transitions for music
if(music_fade != NONE)
{
	if(music_fade == IN)
	{	
		_gain = audio_sound_get_gain(music_fade_next_song);
		// play the song, if not already
		if(!audio_is_playing(music_fade_next_song)) 
		{
			next_inst = audio_play_sound(music_fade_next_song, 1000, true, 0);
			_gain = 0;
		}
		
		// if gsin id zero, start tarnsition to music gain level
		if(_gain == 0) audio_sound_gain(next_inst, music_gain, music_fade_duration);
		// stop transitioning
		if(_gain >= music_gain)	
		{
			music_fade_prev_song = music_fade_next_song;
			music_fade_next_song = -1;
			music_fade = NONE;
		}
	} else if(music_fade == OUT) {
		_gain = audio_sound_get_gain(music_fade_prev_song);
		if(_gain <= 0){
			if(audio_is_playing(music_fade_prev_song)) audio_stop_sound(music_fade_prev_song);
			if(music_fade_next_song != -1)
			{
				music_fade = audio_exists(music_fade_next_song);
			} else {
				music_fade = NONE;
			}
		} else if(_gain = music_gain){
			audio_sound_gain(music_fade_prev_song, 0, music_fade_duration);
		}
	}
}


