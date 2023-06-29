/// @description Insert description here
// You can write your code in this editor
if (audio_sound_get_gain(sound_id) <= 0)
{
	audio_stop_sound(sound_id);
	instance_destroy();
	show_debug_message("Music stopped successfully");
}
