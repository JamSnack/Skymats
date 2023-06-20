// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
audio_listener_orientation(0, 0, -1, 0, 1, 0);

function audio_play_sound_custom(sound_id, priority, loops, halts_existing=true)
{
	if (halts_existing && audio_is_playing(sound_id))
		audio_stop_sound(sound_id);
		
	audio_play_sound(sound_id, priority, loops);
}

function audio_play_sound_in_world(sound_id, priority, loops, halts_existing=false, x, y)
{
	if (halts_existing && audio_is_playing(sound_id))
		audio_stop_sound(sound_id);
		
	audio_play_sound_at(sound_id, x, y, 0, 100, 300, 1, loops, priority);
}