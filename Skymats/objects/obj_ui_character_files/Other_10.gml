/// @description Start game
global.is_host = true;

//Pass the character file into networkingControl for the player to load during its create event.
if (character_selected != -1)
{
	networkingControl.character_file = character_files[character_selected];
	room_goto(rm_small);
}
else 
{
	networkingControl.character_file = -1;
	room_goto(rm_character_creator);
}

//Load the expedition into global-scope.
if (expedition_selected != -1)
	load_expedition(expedition_files[expedition_selected]);
else
{
	init_expedition();
}

//Effects
audio_play_sound(snd_entered_empyrious, 10, false);