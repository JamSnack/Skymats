/// @description Insert description here
// You can write your code in this editor

if (collision_rectangle(bbox_left, bbox_top - 16*2, bbox_right, bbox_top, OBSTA, false, true) == noone)
{
	obstruction = false;
	if (fuel > 1 && powered)
	{
		global.platform_height -= 1;
		fuel -= 1;
		target_y -= 1;
		
		if (spawn_high_island_delay < 0 && (fuel > 400))
		{
			instance_create_layer(bbox_left + irandom_range(-250, 250), WORLD_BOUND_TOP - 300, "Instances", obj_island_generator);
			spawn_high_island_delay = 60*15;
		}
		else spawn_high_island_delay--;
	}

	if (y != target_y)
	{
		y = lerp(y, target_y, 0.1);
	
		obj_market.y = bbox_top-74;
	
		if (collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true) != noone)
		{
			obj_player.y = bbox_top-9;
			obj_player.vspd = 0;
		}
	}
}
else obstruction = true;


//move everything
with (TILE)
	x += SCROLL_SPEED;