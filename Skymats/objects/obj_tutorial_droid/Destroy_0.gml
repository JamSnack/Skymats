/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if (instance_exists(tutorialControl))
{
	instance_create_layer(x, y, "Instances", obj_item, {item_id: ITEM_ID.fuel_cell});
	tutorialControl.stage = 4;
	tutorialControl.update_stage = true; //This procedure will increment the stage into 5
}