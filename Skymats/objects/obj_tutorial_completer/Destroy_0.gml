/// @description Insert description here
// You can write your code in this editor

if (!global.tutorial_complete)
{
	instance_create_layer(0, 0, "Instances", efct_logo);
	audio_play_sound(snd_Skymats, 10, false);
	global.tutorial_complete = true;
	
	with (obj_platform)
		show_engine_tutorial = false;
}