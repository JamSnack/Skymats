// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
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
		case 4:  { cull_enemies();  } break;
		case 6:  { sync_mobs(); } break;
		case 5:  { spawn_mobs(); } break;
		case 9:  { sync_mobs(); } break;
		case 12: { sync_mobs(); } break;
		case 15: { sync_mobs(); } break;
		case 16: { sync_platform(); } break;
	}
	
	current_interval++;
	if (current_interval > SYSTEM_INTERVAL) current_interval = 0;
}

function sync_platform()
{
	if (global.is_host && instance_exists(obj_platform))
	{
		send_data({cmd: "sync_platform", height: global.platform_height, target: obj_platform.target_y, powered: obj_platform.powered, obstructed: obj_platform.obstruction, fuel: obj_platform.fuel, max_fuel: obj_platform.max_fuel});
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
			if (x-8 > WORLD_BOUND_RIGHT || y > WORLD_BOUND_BOTTOM+300)
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
			if (y > WORLD_BOUND_BOTTOM+300)
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
			instance_create_layer(-270, global.platform_height + 100 + irandom(1000), "Instances", obj_island_generator);
		}
		else if (interval_delay > 0) 
		{
			/*if (_tiles < 100)
				interval_delay = 0;
			else if (_tiles < 300)
				interval_delay -= 3;
			else if (_tiles < 650)
				interval_delay -= 2;
			else*/
			interval_delay--;
		}
	}
}

function sync_mobs()
{
	if (global.is_host)
	{
		with (ENEMY)
			send_data({cmd: "enemy_pos", x: x, y: y, connected_id: connected_id, hp: hp, object: object_index});
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
		var _y = player.y;
		var _x = player.x;
	
		if (global.platform_height < -3000)
		{
			enemy_spawn_delay = 60*60*irandom_range(1,2);
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
}