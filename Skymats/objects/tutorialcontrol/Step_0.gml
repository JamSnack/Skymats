/// @description Insert description here
// You can write your code in this editor

//Keep the elevator disabled until it's time to leave
if (stage < 5 && instance_exists(obj_platform))
	obj_platform.powered = false;
	
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
		}
		break;
		
		case 2:
		{
			x = 28.5;
			y = 586;
			global.can_jetpack = true;
		}
		break;
		
		case 3:
		{
			x = 2513.44;
			y = 136;
			global.can_grapple = true;
		}
		break;
		
		case 4:
		{
			x = 2513.44;
			y = 122;
		}
		break;
	}
}