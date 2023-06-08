// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function audio_play_sound_custom(sound_id, priority, loops, halts_existing=true)
{
	if (halts_existing && audio_is_playing(sound_id))
		audio_stop_sound(sound_id);
		
	audio_play_sound(sound_id, priority, loops);
}