/// @description 

sound_queue = ds_queue_create();

music_fade_next_song = The_Verdant_Grove_LOOP; 
next_inst = undefined;
music_fade_prev_song = The_Verdant_Grove_LOOP;
prev_inst = undefined;
music_fade = NONE;
music_fade_duration = 5000;
music_gain = 1;
hudfx_gain = 1;
sndfx_gain = 1;
music_load = 0;
hudfx_load = 0;
sndfx_load = 0;
groups_loaded = 0;

group_load_update_interval = 4;
alarm[0] = 1;

audio_group_load(GameMusic);
audio_group_load(SoundEffects);
audio_group_load(HUDEffects);
