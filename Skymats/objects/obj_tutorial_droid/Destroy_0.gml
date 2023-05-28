/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if (instance_exists(tutorialControl))
{
	tutorialControl.stage = 4;
	tutorialControl.update_stage = true; //This procedure will increment the stage into 5
}