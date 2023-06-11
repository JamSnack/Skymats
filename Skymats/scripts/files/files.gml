   // Script assets have changed for v2.3.0 see
 // Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
#macro EXCEPT catch (e) { show_debug_message(e); }

function save_character(username = "character")
{
	if (instance_exists(obj_player))
	{
		with (obj_player)
		{
			var save_struct = {
				stat_grapple_force: stat_grapple_force,
				stat_grapple_range: stat_grapple_range,
				stat_grapple_speed: stat_grapple_speed,
					
				stat_jetpack_cooldown: stat_jetpack_cooldown,
				stat_jetpack_fuel: stat_jetpack_fuel,
				stat_jetpack_regen_rate: stat_jetpack_regen_rate,
				stat_jetpack_strength: stat_jetpack_strength,
					
				stat_mine_cooldown: stat_mine_cooldown,
				stat_mine_level: stat_mine_level,
					
				stat_weapon_cooldown: stat_weapon_cooldown,
				stat_weapon_damage: stat_weapon_damage,
				stat_weapon_knockback: stat_weapon_knockback,
				stat_weapon_range: stat_weapon_range,
					
				upgrades_purchased: upgrades_purchased,
				gold: gold,
				player_level: player_level,
				username: username
			}
				
			var json = json_stringify(save_struct);
			var _buff = buffer_create(string_byte_length(json) + 1, buffer_fixed, 1);
			buffer_write(_buff, buffer_string, json);
			buffer_save(_buff, string(username)+".charc");
	
			//cleanup
			buffer_delete(_buff);
		}
	}
}

function save_expedition(expedition_name = "exped")
{
	if (global.is_host)
	{
		if (instance_exists(obj_platform))
		{
			with (obj_platform)
			{
				var save_struct = {
					platform_height: global.platform_height,
					tutorial_complete: global.tutorial_complete,
					stored_resources: global.stored_resources,
					stored_resources_unlocked: global.stored_resources_unlocked,
					auto_burn: global.stored_resources_auto_burn,
					burning: global.stored_resource_to_burn,
					fuel: fuel,
					max_fuel: max_fuel,
					game_progress: global.game_progress
				}
				
				var json = json_stringify(save_struct);
				var _buff = buffer_create(string_byte_length(json) + 1, buffer_fixed, 1);
				buffer_write(_buff, buffer_string, json);
				buffer_save(_buff, string(expedition_name)+".exped");
	
				//cleanup
				buffer_delete(_buff);
			}
		}
	}
}

function save_game()
{
	if (instance_exists(obj_player))
		save_character(obj_player.username);
		
	save_expedition(networkingControl.exped_name);
	
	instance_create_layer(x, y, "Instances", efct_game_save);
}

function load_character(file)
{
	if (file_exists(file))
	{
		var _buff = buffer_load(file);	
		var _string = buffer_read(_buff, buffer_string);
		var _data = json_parse(_string);
	
		try
		{
			stat_grapple_force = _data.stat_grapple_force; //How much force is applied to the player +0.5
			stat_grapple_speed = _data.stat_grapple_speed; //How fast the hook travels +2
			stat_grapple_range = _data.stat_grapple_range; //How far the hook can go (600 is about the edge of the screen) +20

			//- mining tool
			stat_mine_level = _data.stat_mine_level; //Determines which blocks can be destroyed and not
			stat_mine_cooldown = _data.stat_mine_cooldown; //Determines how much time must pass before the pickaxe can be swung again

			//- jetpack
			stat_jetpack_fuel = _data.stat_jetpack_fuel; //How many frames can pass before the jetpack runs out of fuel. +30
			stat_jetpack_strength = _data.stat_jetpack_strength; //How fast the jetpack boosts you + 0.025
			stat_jetpack_cooldown = _data.stat_jetpack_cooldown; //How many frames of inactivity need to pass before the jetpack fuel begins regenerating -10
			stat_jetpack_regen_rate = _data.stat_jetpack_regen_rate; //How much jetpack fuel regenerates each frame. +0.05

			//- weapon
			stat_weapon_cooldown = _data.stat_weapon_cooldown; //How many frames it takes to prepare the auto-attack
			stat_weapon_damage = _data.stat_weapon_damage;
			stat_weapon_knockback = _data.stat_weapon_knockback;
			stat_weapon_range = _data.stat_weapon_range;
	
			//Purchase
			upgrades_purchased = _data.upgrades_purchased;
			gold = _data.gold;
			username = _data.username;
			player_level = _data.player_level;
		}
		catch (e)
		{
			show_debug_message("Error loading file");
			show_debug_message(e);
		}
	}
}


function read_character(file)
{
	if (file_exists(file))
	{
		var _buff = buffer_load(file);	
		var _string = buffer_read(_buff, buffer_string);
		var _data = json_parse(_string);
	
		try
		{
			var data_struct = 
			{
				/*
				stat_grapple_force : _data.stat_grapple_force,
				stat_grapple_speed : _data.stat_grapple_speed,
				stat_grapple_range : _data.stat_grapple_range,

				//- mining tool
				stat_mine_level : _data.stat_mine_level, 
				stat_mine_cooldown : _data.stat_mine_cooldown, 

				//- jetpack
				stat_jetpack_fuel : _data.stat_jetpack_fuel, 
				stat_jetpack_strength : _data.stat_jetpack_strength,
				stat_jetpack_cooldown : _data.stat_jetpack_cooldown,
				stat_jetpack_regen_rate : _data.stat_jetpack_regen_rate,

				//- weapon
				stat_weapon_cooldown : _data.stat_weapon_cooldown, 
				stat_weapon_damage : _data.stat_weapon_damage,
				stat_weapon_knockback : _data.stat_weapon_knockback,
				stat_weapon_range : _data.stat_weapon_range,
	
				//Purchase
				upgrades_purchased : _data.upgrades_purchased,*/
				gold : _data.gold,
				player_level : _data.player_level,
				username: _data.username
			}
			
			return data_struct;
		}
		catch (e)
		{
			return -1;
			show_debug_message("Error loading file");
			show_debug_message(e);
		}
	}
}



function load_expedition(file)
{
	//NOTE: This function is expected to be executed twice. Once before obj_platform is loaded, and once after obj_platform is loaded.
	show_debug_message("Attempting to load " + file);
	
	if (file_exists(file))
	{
		var _buff = buffer_load(file);	
		var _string = buffer_read(_buff, buffer_string);
		var _data = json_parse(_string);
	
		try
		{
			//Platform
			global.platform_height = _data.platform_height;
			global.tutorial_complete = _data.tutorial_complete;
			//global.stored_resource_to_burn = _data.burning;
		} EXCEPT
		
		//Load unlocked resources
		try
		{
			for (var _i = 0; _i < array_length(_data.stored_resources_unlocked); _i++)
			{
				if (_data.stored_resources_unlocked[_i])
					global.stored_resources_unlocked[_i] = 1;
			}
		} EXCEPT
		
		//Load resources
		try
		{
			for (var _i = 0; _i < array_length(_data.stored_resources); _i++)
			{
				global.stored_resources[_i] = _data.stored_resources[_i];
			}
		} EXCEPT
		
		//Load game progress
		try
		{
			global.game_progress = _data.game_progress;
		} EXCEPT
		
		
		/*
		//Load auto-burn list
		try
		{
			for (var _i = 0; _i < array_length(_data.auto_burn); _i++)
			{
				global.auto_burn[_i] = _data.auto_burn[_i];
			}
		}
		*/
		
		
		if (instance_exists(obj_platform))
		{
			//Load platform-scope variables
			obj_platform.fuel = _data.fuel;
			obj_platform.max_fuel = _data.max_fuel;
		}
	}
}


// Read the expedition file and load its contents into a file object
function read_expedition(file)
{
	if (file_exists(file))
	{
		
		var _buff = buffer_load(file);	
		var _string = buffer_read(_buff, buffer_string);
		var _data = json_parse(_string);
	
		try
		{
			var _c = get_background_colors(-_data.platform_height);
			
			var data_struct = 
			{
				platform_height : _data.platform_height,
				tutorial_complete : _data.tutorial_complete,
				colors : [make_color_rgb(_c[0][0]*255, _c[0][1]*255, _c[0][2]*255), make_color_rgb(_c[1][0]*255, _c[1][1]*255, _c[1][2]*255)],
				resources_discovered : 0
			}
			
				}
		catch (e)
		{
			show_debug_message("Error reading file");
			show_debug_message(e);
			//return -1;
		}
			
		for (var _i = 0; _i < array_length(_data.stored_resources_unlocked); _i++)
		{
			if (_data.stored_resources_unlocked[_i])
				data_struct.resources_discovered++;
		}
			
		return data_struct;
	}
}

function multi_string(spacer = "")
{
	var _str = "";

    for (var i = 1; i < argument_count; i ++)
        _str += string(argument[i]) + spacer;

    return _str;
}

function load_dungeon(file_name)
{
	
	//Used to load base64 encoded dungeons from ".dngn" files.
	//Once loaded, a dungeon will iteratively be constructed and the game-state will be flipped to dungeon mode.
	if (file_exists(working_directory + "/Dungeons/"+file_name+".dngn"))
	{
		
		var _buff = buffer_load(working_directory + "/Dungeons/"+file_name+".dngn");	
		var _string = buffer_read(_buff, buffer_string);
		var _data = json_parse(_string);
		var _host = global.is_host;
		
		for (var i=0; i < array_length(_data.instances); i++)
		{
			var _i = _data.instances[i];
			var _obj = asset_get_index(_i.obj);
			
			//Host will load all instances, !host will ignore enemies since they will be hosted on the host's game anyway.
			if (_host || (!_host && object_get_parent(_obj) != ENEMY) )
				instance_create_layer(_i.x, global.platform_height+_i.y-1500, "Instances", asset_get_index(_i.obj), {image_angle: _i.image_angle, image_xscale: _i.image_xscale, image_yscale: _i.image_yscale} );
		}
		
		
		//Clear stuff
		var clear_condition_object = instance_create_layer(0, 0, "Instances", obj_dungeon_clear_condition, { next_dungeon: _data.next_dungeon });
		var clear_list = _data.clear;
		
		if (is_array(clear_list))
		{
			for (var i=0; i < array_length(clear_list); i++)
			{
				var _c = clear_list[i];
				var inst = instance_nearest(_c[1], global.platform_height+_c[2]-1500, asset_get_index(_c[0]));
				if (inst != noone)
				{
					ds_list_add(clear_condition_object.inst_list, inst);
					show_debug_message("adding clear con...");
					show_debug_message("instance: " + string(inst));
				}
				else show_debug_message("no instance found");
				//clear_condition_object.watch_list[| i] = inst;
			}
		}
	}
}

function save_dungeon(file_name, instance_list, next_dungeon)
{
	//Saves a list of instances to a ".dngn" file after base64 encoding them. Targets the "Dungeon" folder. Useful during development.
	var _amt = ds_list_size(instance_list);
	var master_string = "{ \"instances\": [";
	var clear_condition = noone;
	
	for (var _i = 0; _i < _amt; _i++)
	{
		var _inst = instance_list[| _i];
		
		if (instance_exists(_inst))
		{
			with (_inst)
			{
				if (object_index == obj_dungeon_clear_condition)
				{
					clear_condition = id;
				}
				//We want to save most important variables. Hardcode these for now.
				else
				{
					var _data = 
					{
						obj: object_get_name(object_index),
						x: x,
						y: y,
						image_xscale: image_xscale,
						image_yscale: image_yscale,
						image_angle: image_angle
					}
					
					master_string += json_stringify(_data);
					
					if (_i+1 < _amt)
						master_string += ",";
				}
			}
		}
	}
	
	//Add next dungeon clause
	master_string += "], \"next_dungeon\": \"" + next_dungeon +"\"";
	
	//Add clear-condition list
	if (instance_exists(clear_condition))
	{
		var _data = 
		{
			clear: []
		}
		
		var inst_list = clear_condition.inst_list;
		
		for (var i=0; i < ds_list_size(inst_list); i++)
		{
			var inst = inst_list[| i];
			if (instance_exists(inst))
				array_push(_data.clear, [object_get_name(inst.object_index), inst.x, inst.y]);
		}
			
		
		master_string += ", " + string_delete(json_stringify(_data), 1, 1);
	}
	//Encode the data
	
	//Save data
	//master_string += "}";
	var _buff = buffer_create(string_byte_length(master_string) + 1, buffer_fixed, 1);
	buffer_write(_buff, buffer_string, master_string);
	buffer_save(_buff, working_directory+"/Dungeons/"+file_name+".dngn");
	
	//cleanup
	buffer_delete(_buff);
	
	show_debug_message("Dungeon saved successfully.");
}