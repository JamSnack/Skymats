/// @description Insert description here
// You can write your code in this editor

//Keep the elevator disabled until it's time to leave
if (stage < 5 && instance_exists(obj_platform))
	obj_platform.powered = false;
	
if (global.tutorial_complete == true)
	instance_destroy();
	
//Increase tut stage
if (instance_exists(obj_player) && collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true))
{
	stage++;
	
	switch stage
	{
		case 1:
		{
			x = 400;
			y = 602;
			tutorial_index = 2;
			instance_create_layer(0, 0, "Instances", efct_notification, {text: "Mine tiles with left click."});
		}
		break;
		
		case 2:
		{
			x = 28.5;
			y = 586;
			global.can_jetpack = true;
			tutorial_index = 3;
			instance_create_layer(0, 0, "Instances", efct_notification, {text: "Airpack unlocked! Hold JUMP to fly!"});
		}
		break;
		
		case 3:
		{
			x = 2513.44;
			y = 136;
			global.can_grapple = true;
			tutorial_index = 4;
			instance_create_layer(0, 0, "Instances", efct_notification, {text: "Grapple-Claw unlocked! Press right click to grapple to surfaces!"});
		}
		break;
		
		case 4:
		{
			x = 1440;
			y = 800;
			tutorial_index = 5;
			instance_create_layer(0, 0, "Instances", efct_notification, {text: "Defeat the enemy. Collect the Fuel-Cell."});
		}
		break;
		
		case 5:
		{
			x = 0;
			y = 0;
			tutorial_index = 0;
			instance_create_layer(0, 0, "Instances", efct_notification, {text: "Place the Fuel-Cell into the engine!"});
			obj_platform.fuel += 1500;
		}
		break;
	}
}