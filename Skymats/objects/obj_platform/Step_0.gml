/// @description Insert description here
// You can write your code in this editor

//Keep the platform unpowered during dungeon content.
if (global.dungeon)
	powered = false;

//Approach dungeons, otherwise follow normal procedure regarding engine use, fuel, and flight
if (approach_dungeon)
{
	//This routine is used to approach a dungeon and enter it.
	//NOTE: approach_dungeon must be set to false by an obj_dungeon_dock_point entity.
	with (TILE)
	{
		y += 1;
		update_shadow(shadow);
	}
		
	with (obj_dungeon_dock_point)
		y += 1;
		
	with (obj_island_marker)
		y += 1;
		
	with (ENEMY)
		y += 1;
		
	with (NOCOL)
	{
		y += 1;
		update_shadow(shadow);
	}

	//Lerp naughty players to the correct location
	with (obj_player)
	{
		if (x < other.bbox_left + 6 || x > other.bbox_right - 6)
		{
			x = lerp(x, other.x, 0.015);
			hspd = 0;
		}
			
		if (y > other.bbox_top - 8)
		{
			y = lerp(y, other.bbox_top-20, 0.05);
			vspd = 0;
		}
	}
		
	if (!instance_exists(obj_dungeon_dock_point))
	{
		approach_dungeon = false;
		
		//SNAP naughty players to the correct location
		with (obj_player)
		{
			if (x <= other.bbox_left || x >= other.bbox_right)
				x = other.x;
			
			if (y > other.bbox_top)
				y = other.bbox_top-10;
		}
	}
}
else if (collision_rectangle(bbox_left + 1, bbox_top - 16*2, bbox_right-1, bbox_top-1, OBSTA, false, true) == noone)
{
	obstruction = false;
	if (fuel > 1 && powered && power_delay <= 0)
	{
		global.platform_height -= 1;
		fuel -= (1 - (fuel_efficieny/100));
		
		if (global.tutorial_complete && spawn_high_island_delay < 0 && (fuel > 400))
		{
			instance_create_layer(bbox_left + irandom_range(-250, 250), WORLD_BOUND_TOP - 300, "Instances", obj_island_generator);
			repeat(irandom(5))
			{
				part_particles_create(global.foreground_particles, 10+irandom(room_width-400), global.platform_height - 300, global.particle_library.foreground_cloud, 1);
				part_particles_create(global.background_particles, 10+irandom(room_width-400), global.platform_height - 300, global.particle_library.background_cloud1, 1);
			}
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
	obj_fuel_storage.y = y-36;
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

//fuel clamp
fuel = clamp(fuel, 0, max_fuel);

//Position the target coordinate of the platform at 938 pixels under WORLD_BOUND_TOP.
if (target_y != global.platform_height+938)
	target_y = global.platform_height+938;

//Powered
if (global.is_host && powered && power_delay > 0)
	power_delay--;
else if (!powered) power_delay = 60;

if (powered && fuel <= 1)
	powered = false;

if (keyboard_check_released(ord("G")))
{
	if (!powered && fuel >= fuel_power_threshold)
		powered = true;
	else powered = false;
}

//lerp fuel
if (draw_fuel != fuel)
	draw_fuel = lerp(draw_fuel, fuel, 0.05);

//move everything
if (SCROLL_CONDITIONS)
{
	with (TILE)
	{
		x += SCROLL_SPEED;
		layer_sprite_x(shadow, x+2); //Update shadows
	}
}