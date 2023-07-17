/// @description Insert description here
// You can write your code in this editor
event_inherited();

//global.is_host = true;
//networkingControl.loading_world = true;
room_goto(rm_game);

global.is_host = true;
global.tutorial_complete = true; //setting for rm_game

//Load the expedition into global-scope.
init_expedition();

//Effects
audio_play_sound(snd_entered_empyrious, 10, false);

//instance_create_layer(0, 0, "Instances", obj_ui_character_files);


//TODO: Make the button draw the text
with (obj_text)
	instance_destroy();
	
instance_destroy();