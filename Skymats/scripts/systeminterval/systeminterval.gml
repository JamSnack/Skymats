// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

//Used for ignoring packets regarding recently destroyed instances in multiplayer.
#macro RECENTLY_DESTROYED_LIST_MAX_SIZE 5
global.recently_destroyed_list = ds_list_create();

#macro SYSTEM_INTERVAL 16

function process_system_interval()
{
	static current_interval = 0;
	
	switch (current_interval)
	{
		case 0:  { sync_player_stats(); sync_mobs(); } break;
		case 1:  { cull_tiles();        } break;
		case 2:  { create_new_islands(); } break;
		case 3:  { sync_platform(); } break;
		case 4:  { cull_enemies(); cull_items(); } break;
		case 5:  { spawn_mobs(); } break;
		case 6:  { sync_mobs(); } break;
		case 7:  { manage_auto_burn(); } break;
		case 9:  { sync_mobs(); } break;
		case 10: { manage_recently_destroyed(); } break;
		case 11: { check_height(); } break;
		case 12: { manage_auto_burn(); } break;
		case 16: { sync_platform(); } break;
	}
	
	current_interval++;
	if (current_interval > SYSTEM_INTERVAL) current_interval = 0;
}

//Checks the height and certain conditions to determine if an event should be activated or not.
function check_height()
{
	var _height = global.platform_height;
}

function manage_auto_burn()
{
	static resource_to_check = 1;
	
	if (global.stored_resources_auto_burn[resource_to_check] && global.stored_resources[resource_to_check] > 0)
	{
		if (global.stored_resource_to_burn != resource_to_check)
		{
			global.stored_resource_to_burn = resource_to_check;
		
			//Reset relevant Ui
			if (instance_exists(obj_ui_fuel_menu))
				with (obj_ui_fuel_menu) { surface_free(window_surface) };
		}
	}
	else
	{
		if (resource_to_check == global.stored_resource_to_burn)
			global.stored_resource_to_burn = 0;
		
		resource_to_check++;
		
		if (resource_to_check >= ITEM_ID.last)
			resource_to_check = 1;
	}
}

function manage_recently_destroyed()
{
	//Remove the oldest ID stored in the recently_destroyed_list
	if (ds_list_size(global.recently_destroyed_list > RECENTLY_DESTROYED_LIST_MAX_SIZE))
		ds_list_delete(global.recently_destroyed_list, 0);
}

function sync_platform()
{
	if (global.is_host && instance_exists(obj_platform))
	{
		//Send platform stats
		send_data({cmd: "sync_platform", height: global.platform_height, target: obj_platform.target_y, powered: obj_platform.powered, obstructed: obj_platform.obstruction, fuel: obj_platform.fuel, max_fuel: obj_platform.max_fuel, stored_resources: global.stored_resources, unlocked: global.stored_resources_unlocked, auto: global.stored_resource_to_burn, burn: global.stored_resources_auto_burn });
	}
}

function sync_player_stats()
{
	if (instance_exists(obj_player))
	{
		with (obj_player)
			send_data({cmd: "player_stats", id: global.client_id, hp: hp, max_hp: max_hp});
	}
}

function cull_tiles()
{
	if (global.tutorial_complete)
	{
		with (TILE)
		{
			if (x-8 > WORLD_BOUND_RIGHT || y > WORLD_BOUND_BOTTOM+768)
				instance_destroy();
		}
	}
}

function cull_items()
{
	if (global.tutorial_complete)
	{
		with (obj_item)
		{
			if (x-8 > WORLD_BOUND_RIGHT || y > WORLD_BOUND_BOTTOM+768)
				instance_destroy();
		}
	}
}

function cull_enemies()
{
	if (global.tutorial_complete)
	{
		with (ENEMY)
		{
			if (y > WORLD_BOUND_BOTTOM+768)
				instance_destroy();
		}
	}
}

function create_new_islands()
{
	if (global.is_host && global.tutorial_complete)
	{
		static interval_delay = 0;
		
		var _tiles = instance_number(TILE);
	
		if (_tiles < 1400 && interval_delay <= 0)
		{
			interval_delay = (SYSTEM_INTERVAL)*(8 + irandom(4));
			var chosen_y = global.platform_height + 100 + irandom(1000);
			instance_create_layer(-270, chosen_y, "Instances", obj_island_generator);
			
			//Create a double-island
			if (irandom(2) == 1)
			{
				instance_create_layer(-270 - 17*16 + 3 + SCROLL_SPEED, chosen_y, "Instances", obj_island_generator);
				interval_delay += SYSTEM_INTERVAL*6;
				
				//Create a triple-island!
				if (irandom(2) == 1)
				{
					instance_create_layer(-270 + (-17*16 + 3 + SCROLL_SPEED)*2, chosen_y, "Instances", obj_island_generator);
					interval_delay += SYSTEM_INTERVAL*6;
				}
			}
		}
		else if (interval_delay > 0) 
		{
			interval_delay--;
		}
	}
}

function sync_mobs()
{
	if (global.is_host && global.multiplayer)
	{
		with (ENEMY)
			send_enemy_position();
	}
}

function spawn_mobs()
{
	static enemy_spawn_delay = 1;
	
	//Enemy spawning
	if (enemy_spawn_delay <= 0 && global.tutorial_complete && instance_exists(obj_player) && global.is_host && instance_number(ENEMY) < 15)
	{	
		var _p = irandom(instance_number(PLAYER)-1);
		var player = instance_find(PLAYER, _p);
		//var _y = player.y;
		var _x = player.x;
	
		if (global.platform_height < -3000)
		{
			enemy_spawn_delay = 45*15*irandom_range(1,2) + global.platform_height/100;
			instance_create_layer(WORLD_BOUND_RIGHT, WORLD_BOUND_TOP-100, "Instances", obj_vector_weevil);
		}
		
		if (global.platform_height < -3000 && irandom(5) == 1)
		{
			repeat(-floor(global.platform_height/1200))
				instance_create_layer(WORLD_BOUND_RIGHT, WORLD_BOUND_TOP-100, "Instances", obj_vector_weevil);
		}
			
	
		//Other
		var _r = irandom(99999);
	
		if (_r > 0 && _r < 80)
		{
			repeat (_r mod 8)
				instance_create_layer(random_range(_x - CHUNK_WIDTH/2, _x + CHUNK_WIDTH/2), WORLD_BOUND_BOTTOM+60, "Instances", obj_balloonimal);
		}
	}	
	else enemy_spawn_delay--;
	
	//Check if players are in the void
	if (global.is_host)
	{
		with (PLAYER)
		{
			if (instance_number(obj_void_fiend) < 5)
				instance_create_layer(choose(0, room_width), WORLD_BOUND_BOTTOM+768, "Instances", obj_void_fiend);
			else break;
		}
	}
}