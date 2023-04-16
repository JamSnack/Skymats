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
	}
	
	current_interval++;
	if (current_interval > SYSTEM_INTERVAL) current_interval = 0;
}

function check_for_desync()
{
	if (global.is_host)
	{
		static current_position = 0;
	
		var _t = global.tiles_list.tiles[| current_position++];
		
		//TODO: Send this tile to the clients for comparison.
		//send_data();
	
		if (current_position > global.tiles_list.tiles_list_size)
			current_position = 0;
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
		if (x-8 > room_width)
			instance_destroy();
	}
}

function create_new_islands()
{
	if (global.is_host)
	{
		static interval_delay = 0;
	
		if (instance_number(TILE) < 1200 && interval_delay <= 0)
		{
			interval_delay = 80 + irandom(80);
			instance_create_layer(-100, irandom(room_height-500) + global.platform_height, "Instances", obj_island_generator);
		} else if (interval_delay > 0) interval_delay--;
	}
}