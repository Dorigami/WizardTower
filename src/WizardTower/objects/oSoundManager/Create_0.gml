/// @description 

sound_queue = ds_queue_create();

music_fade_next_song = -1; 
music_fade_prev_song = -1;
music_fade_direction = NONE;
music_fade = 0.5;
music_fade_rate = 0.005;
music_gain = 0.1;
hudfx_gain = 0.8;
sndfx_gain = 0.4;
music_load = 0;
hudfx_load = 0;
sndfx_load = 0;

audio_group_load(GameMusic);
audio_group_load(SoundEffects);
audio_group_load(HUDEffects);
