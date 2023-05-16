/// @description Insert description here
// You can write your code in this editor

if (collision_rectangle(bbox_left + 1, bbox_top - 16*2, bbox_right-1, bbox_top-1, OBSTA, false, true) == noone)
{
	obstruction = false;
	if (fuel > 1 && powered && power_delay <= 0)
	{
		global.platform_height -= 1;
		fuel -= 1;
		
		if (global.tutorial_complete && spawn_high_island_delay < 0 && (fuel > 400))
		{
			instance_create_layer(bbox_left + irandom_range(-250, 250), WORLD_BOUND_TOP - 300, "Instances", obj_island_generator);
			spawn_high_island_delay = 60*15;
		}
		else spawn_high_island_delay--;
	}
}
else
{
	if (obstruction = false)
	{
		obstruction = true;
		y = round(y);
		
		if (!global.tutorial_complete)
			instance_create_layer(0, 0, "Instances", efct_notification, { text: "The Elevator is obstructed! Remove the tiles blocking it so that it can continue to rise."});
	}
}


//Collision and movement stuff
if (y != target_y)
{
	//Move the platform
	y = lerp(y, target_y, 0.1);
	
	// - snap if close to target_y
	if (point_distance(0, y, 0, target_y) < 1)
		y = target_y;
	
	//Move all platform objects
	obj_market.y = bbox_top-74;
	obj_power_button.y = bbox_top-2;
	obj_fuel_storage.y = bbox_top+16;
}

if (y != yprevious)
{
	if (collision_rectangle(bbox_left, ceil(bbox_top)-1, bbox_right, bbox_bottom, obj_player, false, true) != noone)
	{
		obj_player.y = ceil(bbox_top)-9;
			
		if (!obj_player.grappling)
			obj_player.vspd = 0;
	}
}


if (target_y != global.platform_height+938)
	target_y = global.platform_height+938;

//Powered
if (global.is_host && powered && power_delay > 0)
	power_delay--;
else if (!powered) power_delay = 60;

//move everything
if (SCROLL_CONDITIONS)
{
	with (TILE)
		x += SCROLL_SPEED;
}