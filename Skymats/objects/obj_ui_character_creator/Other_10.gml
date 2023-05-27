/// @description Start game
global.is_host = true;

//Goto rm_small
room_goto(rm_small);

networkingControl.username = username;

//Effects
audio_play_sound(snd_entered_empyrious, 10, false);