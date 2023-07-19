// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
global.debug = true;
global.platform_height = 0;
global.tutorial_complete = false;


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
		case 13: { update_music(); } break;
		case 16: { sync_platform(); } break;
	}
	
	current_interval++;
	if (current_interval > SYSTEM_INTERVAL) current_interval = 0;
}

//Checks the height and certain conditions to determine if an event should be activated or not.
function check_height()
{
	static foreground_cloud_timer = 30;
	static background_cloud_timer = 30;
	static background_island_timer = 30;
	static cloud_timer_variation = 0;
	
	var _height = global.platform_height;
	
	//Handle particles
	//- Clouds
	if (foreground_cloud_timer <= 0 && _height < -2000 && _height > -13000)
	{
		foreground_cloud_timer = 20 + irandom(60) + cloud_timer_variation;
		part_particles_create(global.foreground_particles, -300, global.platform_height + irandom(1366) - 100, global.particle_library.foreground_cloud, 1);
	} else if foreground_cloud_timer > 0 foreground_cloud_timer--;
	
	if (background_cloud_timer <= 0 && _height < -2000 && _height > -13000)
	{
		background_cloud_timer = 20 + irandom(70) + cloud_timer_variation;
		part_particles_create(global.background_particles, -300, global.platform_height + irandom(1366) - 100, global.particle_library.background_cloud1, 1);
	} else if background_cloud_timer > 0 background_cloud_timer--;
	
	//- Islands
	if (background_island_timer <= 0 && _height < -5000 && _height > -11000)
	{
		background_island_timer = 100 + irandom(70);
		part_particles_create(global.background_particles, -300, global.platform_height + irandom(1366) - 100, global.particle_library.background_islands1, 1);
	} else if background_island_timer > 0 background_island_timer--;
	
	cloud_timer_variation += sin(current_time/1000);
	cloud_timer_variation = clamp(cloud_timer_variation, -5, 90);
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
	if (global.is_host && global.multiplayer && instance_exists(obj_platform))
	{ 
		//Send platform stats
		send_data({cmd: "sync_platform", height: global.platform_height, target: obj_platform.target_y, powered: obj_platform.powered, obstructed: obj_platform.obstruction, fuel: obj_platform.fuel, max_fuel: obj_platform.max_fuel, unlocked: global.stored_resources_unlocked, pilot: obj_platform.waiting_for_pilot, dung: global.dungeon, dung_load: "temp_dungeon"});
	}
}

function sync_player_stats()
{
	if (global.multiplayer && instance_exists(obj_player))
	{
		with (obj_player)
			send_data({cmd: "player_stats", id: global.client_id, hp: hp, max_hp: max_hp});
	}
}

function cull_tiles()
{
	static current_tile = -1;
	static current_nocol = -1;
	
	if (global.tutorial_complete)
	{
		
		//Cull tiles in chunks
		repeat(180)
		{
			with (instance_find(TILE, current_tile--))
			{
				if (x-8 > WORLD_BOUND_RIGHT || y > WORLD_BOUND_BOTTOM+768)
				{
					instance_destroy();
				}
			}
			
			//Break and then reset
			if (current_tile < 0)
			{
				current_tile = instance_number(TILE)-1;
				//show_debug_message("reseting current_tile");
				break;
			}
		}
		
		//show_debug_message("current_tile is: " + string(current_tile));
		
		//Cull NOCOL instances in chunks
		repeat(50)
		{
			with (instance_find(NOCOL, current_nocol--))
			{
				if (x-8 > WORLD_BOUND_RIGHT || y > WORLD_BOUND_BOTTOM+768)
				{
					instance_destroy();
				}
			}
			
			//Break and then reset
			if (current_nocol < 0)
			{
				current_nocol = instance_number(NOCOL)-1;
				break;
			}
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

#macro MOB_CAP 20

global.enemy_spawn_credits = 0;

function spawn_mobs()
{
	//Init
	static enemy_spawn_delay = room_speed*15;
	
	//Count down spawn timer
	if (enemy_spawn_delay > 0)
		enemy_spawn_delay--;
		
	else if (global.tutorial_complete && instance_exists(obj_player) && global.is_host && instance_number(ENEMY) < MOB_CAP)
	{	
		//select a random player to spawn things onto
		//var _p = irandom(instance_number(PLAYER)-1);
		//var player = instance_find(PLAYER, _p);
		
		//Shop for a mob!
		if (global.enemy_spawn_credits > 0)
		{
			var _height = global.platform_height;
			
			for (var i = ENEMY.last-1, i > 0; i--)
			{
				var enemy = global.enemies[i];
				
				//Purchase a mob to spawn that is within the height range and is affordable.
				if (_height >= enemy.max_height && _height <= enemy.min_height && enemy.cost >= global.enemy_spawn_credits)
				{
					
					
					break;
				}
				else continue;
			}
		}
		
		//reset timer
		enemy_spawn_delay = room_speed*(2 + irandom(13)); //Spawn an enemy every 2 to 15 seconds
	}	
	
	//Spawn Void Entities
	if (global.is_host)
	{
		with (PLAYER)
		{
			if (y > WORLD_BOUND_BOTTOM && instance_number(obj_void_fiend) < 5)
				instance_create_layer(choose(0, room_width), WORLD_BOUND_BOTTOM+768, "Instances", obj_void_fiend);
			else break;
		}
	}
}

function update_music()
{
	static current_music = noone;
	
	if (!global.tutorial_complete)
		return 0;
		
	//Change background music based on certain conditions
	if (instance_number(ENEMY) > 14 && current_music != snd_enemies_appear)
	{
		if (!audio_is_playing(snd_enemies_appear))
		{
			fade_out_music(current_music);
			audio_play_sound(snd_enemies_appear, 10, true);
			audio_sound_gain(snd_enemies_appear, 0.5, 5000);
			current_music = snd_enemies_appear;
		}
	} 
	else if (instance_number(ENEMY) < 9)
	{
		fade_out_music(current_music);
		current_music = noone;
	}
}

function fade_out_music(sound_id)
{
	if (audio_is_playing(sound_id) && !instance_exists(obj_fade_out_music))
		instance_create_layer(0, 0, "Instances", obj_fade_out_music, { sound_id: sound_id });
}