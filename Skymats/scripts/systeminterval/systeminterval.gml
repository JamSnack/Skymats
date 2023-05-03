// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
global.platform_height = 0;

#macro SYSTEM_INTERVAL 16

global.tiles_list = {
	tiles : ds_list_create(),
	tiles_list_size : 0,
	add : function(id, item_id, x, y)
	{
		ds_list_add(tiles, [id, item_id, x, y]);
		tiles_list_size += 1;
	},
	remove : function(position)
	{
		ds_list_delete(tiles, position);
		tiles_list_size -= 1;
	},
	to_string : function()
	{
		//returns a json string of the contents of tiles
		var str = "{ \"list\": ["
		for (var i=0; i<tiles_list_size; i++)
			str += string(tiles[| i]) + ",";
			
		str += "]}";
		return str;
	}
};

function process_system_interval()
{
	static current_interval = 0;
	
	switch (current_interval)
	{
		case 0: { sync_player_stats(); } break;
		case 1: { cull_tiles();        } break;
		case 2: { create_new_islands(); } break;
		case 3: { sync_platform(); } break;
		case 7: { sync_mobs(); } break;
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
	with (TILE)
	{
		if (x-8 > WORLD_BOUND_RIGHT || y > WORLD_BOUND_BOTTOM+300)
			instance_destroy();
	}
}

function create_new_islands()
{
	if (global.is_host)
	{
		static interval_delay = 0;
		
		var _tiles = instance_number(TILE);
	
		if (_tiles < 1200 && interval_delay <= 0)
		{
			interval_delay = (SYSTEM_INTERVAL)*(13 + irandom(7));
			instance_create_layer(-250, irandom_range(-200, room_height-200) + global.platform_height, "Instances", obj_island_generator);
		}
		else if (interval_delay > 0) 
		{
			if (_tiles < 100)
				interval_delay = 0;
			else if (_tiles < 300)
				interval_delay -= 3;
			else if (_tiles < 650)
				interval_delay -= 2;
			else interval_delay--;
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