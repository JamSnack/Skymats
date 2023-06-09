/// @description Insert description here
// You can write your code in this editor

//Keep the elevator disabled until it's time to leave
if (stage < 5 && instance_exists(obj_platform))
	obj_platform.powered = false;
	
if (global.tutorial_complete == true)
	instance_destroy();
	
//Increase tut stage
if (instance_exists(obj_player) && (collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true) || update_stage))
{
	stage++;
	update_stage = false;
	
	switch stage
	{
		case 1:
		{
			x = 400;
			y = 602;
			tutorial_index = 2;
			instance_create_layer(0, 0, "Instances", efct_notification, {text: "Mining laser activated!"});
		}
		break;
		
		case 2:
		{
			x = 28.5;
			y = 586;
			global.can_jetpack = true;
			tutorial_index = 3;
			instance_create_layer(0, 0, "Instances", efct_notification, {text: "Airpack activated!"});
		}
		break;
		
		case 3:
		{
			x = 1764;
			y = 780;
			global.can_grapple = true;
			tutorial_index = 4;
			instance_create_layer(0, 0, "Instances", efct_notification, {text: "Grapple-Claw activated!"});
		}
		break;
		
		case 4:
		{
			x = -300;//1440;
			y = 0;//800;
			tutorial_index = 5;
			instance_create_layer(1200, 812, "Instances", obj_ancient_stone, {image_xscale: 1, image_yscale: 9.5});
		}
		break;
		
		case 5:
		{
			x = -300;
			y = 0;
			tutorial_index = 0;
			obj_platform.show_engine_tutorial = true;
			
			//destroy barrier in tutorial
			with (instance_nearest(1468, 700, obj_ancient_stone))
				instance_destroy();
		}
		break;
	}
}