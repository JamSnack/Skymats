// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
global.next_id = 1;
global.multiplayer = false; //Whether or not we are now allowed to transmit packets.
global.is_host = false;
global.socket_list = ds_list_create();
global.client_id = -1;
global.world_seed = -1;
global.host_socket = noone; //Clients use this to store the host's socket id.
global.lag = 0;
global.current_tick = 0;
global.game_state = "PLAY";


function connect_to_server(ip, port)
{
	//server_status = "Connecting to server...";
	global.host_socket = network_create_socket(network_socket_tcp);
	
	//Try to connect to the main server. If we fail, look for a server over local host.
	global.multiplayer = true;
	global.is_host = false;
	var _s = network_connect(global.host_socket, ip, port);
	
	if (_s >= 0)
	{
		//Success
		show_debug_message("Connected to server");
		//global.game_state = "LOAD";
	}
	else
	{
		//Fail
		show_debug_message("Failed to connect to server");
	}
}

function send_data(data_struct, specific_socket = -1)
{
	if (global.multiplayer)
	{
		data_struct.tick = global.current_tick;
		var json_map = json_stringify(data_struct);
		var buff = buffer_create(128, buffer_grow, 1);
	
		buffer_seek(buff, buffer_seek_start, 0);
		//var _header = buffer_write(buff, buffer_text, string(string_byte_length(json_map)) + "|");
		var _b = buffer_write(buff, buffer_text, json_map);
	
		//if (_header == -1) then show_debug_message("header write failed.");
		if (_b == -1) then show_debug_message("buffer_write failed.");
	
		//show_debug_message(json_map);
		var packet_sent = -1;
	
		if (global.is_host && specific_socket == -1)
		{
			for (var _c = 0; _c < ds_list_size(global.socket_list); _c++)
				packet_sent = network_send_packet(global.socket_list[| _c], buff, buffer_tell(buff));
		}
		else if (global.is_host && specific_socket != -1)
		{
			packet_sent = network_send_packet(specific_socket, buff, buffer_tell(buff));
		}
		else packet_sent = network_send_packet(global.host_socket, buff, buffer_tell(buff));
	
		if (packet_sent == 0)
		{
			//the send has failed. We need to try again later.
			show_debug_message("FAILED TO SEND: PACKET IS " + string(data_struct.cmd));
		}// else global.packets_sent++;
	
	
		//cleanup
		buffer_delete(buff);
	}
}

function handle_data(data)
{	
	try
	{
		var parsed_data = json_parse(data);
	}
	catch (e)
	{
		//show_debug_message(e);
		return false;
	}
	//show_debug_message("Handling data: "+string(data));
	if (!global.is_host)
	{
		global.lag = 0;//global.current_tick - parsed_data.tick;
	}
	
	if (parsed_data != -1)
	{
		try
		{
		switch parsed_data.cmd
		{	
			
			case "sync_platform":
			{
				//Update general globals
				global.platform_height = parsed_data.height;
				global.stored_resources_unlocked = parsed_data.unlocked;
				
				//Update platform variables
				if (instance_exists(obj_platform))
				{
					with (obj_platform)
					{
						target_y = parsed_data.target;
						powered = parsed_data.powered;
						obstruction = parsed_data.obstructed;
						fuel = parsed_data.fuel
						max_fuel = parsed_data.max_fuel;
						waiting_for_pilot = parsed_data.pilot;
					}
				
				}
				
				//Update fuel menu if open
				if (instance_exists(obj_ui_fuel_menu))
					surface_free(obj_ui_fuel_menu.content_surface);
					
				//If client has no dungeon and the host does, we need to load the dungeon.
				if (!global.dungeon && parsed_data.dung)
				{
					//init_dungeon_load();
					//load_dungeon(parsed_data.dung_load);
				}
				
				//Update dungeon status
				global.dungeon = parsed_data.dung;
			}
			break;
			
			case "request_fuel_added":
			{
				if (instance_exists(obj_platform))
				{
					obj_platform.fuel += parsed_data.amt;

					for (var _j = 0; _j < parsed_data.size; _j++)
					{
						var _i = parsed_data.stash[_j];
						global.stored_resources[_i[0]] += _i[1];
						
						if (global.stored_resources_unlocked[_i[0]] == 0)
						{
							global.stored_resources_unlocked[_i[0]] = 1;
							create_notification( "[wave][scale, 1.5]" + get_item_name(_i[0]) + " [spr_items, "+ string(_i[0]) + "] Discovered!");
						}
					}
				}
			}
			break;
			
			case "request_client_id":
			{
				if (global.is_host)
				{
					var _s = {cmd: "give_client_id", client_id: global.next_id++};
					send_data(_s);
				}
			}
			break;
			
			case "give_client_id":
			{
				if (global.client_id == -1)
				{
					global.client_id = parsed_data.client_id;
					global.current_tick = parsed_data.tick;
					
					//Reset game state
					
					with (ENEMY)
						instance_destroy();
						
					with (TILE)
						instance_destroy();
						
					with (obj_island_marker)
						instance_destroy();
						
					with (obj_item)
						big_suck = true; //collect instead of destroy is probably better, even if exploitable
						
					//Request world data
					sync_chunks();
					
					//Set player coords
					with (obj_player)
						y = global.platform_height;
				}
			}
			break;
			
			case "player_pos":
			{
				var _id = parsed_data.id;
				
				if ( _id != global.client_id && _id != -1)
				{
					var _x = parsed_data.x;
					var _y = parsed_data.y;
					var create_new = true;
				
					with (obj_player_dummy)
					{
						if (_id == connected_id)
						{
							target_x = _x;
							target_y = _y;
							jetpacking_amt = 3*parsed_data.jetpack;
							target_angle = parsed_data.angle;
							
							target_grapple_point_x = parsed_data.gx;
							target_grapple_point_y = parsed_data.gy;
							grapple_direction = parsed_data.gd;
							grapple_amt = 8*parsed_data.gg;
							
							create_new = false;
							
							//Bounce this data to other clients
							if (global.is_host)
							{
								//TODO: Clients should send a "lag" parameter that details by how much they are offset from the host.
								//target_x += (parsed_data.tick)*SCROLL_SPEED;
								send_data(parsed_data);
							}
							else target_x += global.lag*SCROLL_SPEED;
								
							break;
						}
					}
					
					if (create_new)
						instance_create_layer(_x, _y, "Instances", obj_player_dummy, {connected_id: _id, connected_socket: async_load[? "id"]})	
				}
			}
			break;
			
			case "player_stats":
			{
				var _id = parsed_data.id;
				
				if ( _id != global.client_id && _id != -1)
				{
					with (obj_player_dummy)
					{
						if (_id == connected_id)
						{
							hp = parsed_data.hp;
							max_hp = parsed_data.max_hp;
							
							//Bounce this data to other clients
							if (global.is_host)
								send_data(parsed_data);
								
							break;
						}
					}
				}
			}
			break;
			
			case "destroy_tile":
			{
				var _id = parsed_data.owner_id;
				
				if (!global.is_host)
				{
					with (obj_island_marker)
					{
						if (connected_id == _id)
						{
							var _tile = chunk_grid_instance[# parsed_data.x, parsed_data.y];
							if (_tile != 0)
							{
								if (instance_exists(_tile))
								{
									with (_tile) instance_destroy();
									chunk_grid_type[# parsed_data.x, parsed_data.y] = 0;
								}
							}
							break;
						}
					}
				}
			}
			break;
			
			case "update_tile_hp":
			{
				var _id = parsed_data.owner_id;
				
				if (!global.is_host)
				{
					with (obj_island_marker)
					{
						if (connected_id == _id)
						{
							var _tile = chunk_grid_instance[# parsed_data.x, parsed_data.y];
							if (_tile != 0)
							{
								if (instance_exists(_tile))
								{
									with (_tile)
									{
										hp = parsed_data.hp;
										
										draw_damage = true;
										damage = (hp/max_hp)*7;
									}
								}
							}
							break;
						}
					}
				}
			}
			break;
			
			case "request_tile_hit":
			{
				if (global.is_host)
				{
					var _id = parsed_data.owner_id;
					
					with (obj_island_marker)
					{
						if (connected_id == _id)
						{
							var _tile = chunk_grid_instance[# parsed_data.x, parsed_data.y];
							
							if (instance_exists(_tile))
							{
								with (_tile) 
									hurt_tile(parsed_data.damage);
							}
							break;
						}
					}
				}
			}
			break;
			
			case "item_pos":
			{	
				var _x = parsed_data.x;
				var _y = parsed_data.y;
				var _id = parsed_data.connected_id;
				var _item_id = parsed_data.item_id;
				var create_new = true;
				
				with (obj_item)
				{
					if (_id == connected_id)
					{
						target_x = _x;
						target_y = _y;
						create_new = false;
							
						//Break
						break;
					}
				}
					
				if (create_new)
					instance_create_layer(_x, _y, "Instances", obj_item, {connected_id: _id, image_index: _item_id, item_id: _item_id, target_x: _x, target_y: _y})	
			}
			break;
			
			case "enemy_pos":
			{	
				var _x = parsed_data.x;
				var _y = parsed_data.y;
				var _id = parsed_data.connected_id;
				var create_new = true;
				
				if (ds_list_find_index(global.recently_destroyed_list, _id) == -1)
				{
					with (ENEMY)
					{
						if (_id == connected_id)
						{
							target_x = _x + (global.lag * SCROLL_SPEED);
							target_y = _y;
							hp = parsed_data.hp;
							create_new = false;
							random_factor = parsed_data.random_factor;
							hspd = parsed_data.hspd;
							vspd = parsed_data.vspd;
							
							//Break
							break;
						}
					}
					
					if (create_new)
						instance_create_layer(_x, _y, "Instances", parsed_data.object, {connected_id: _id, target_x: _x, target_y: _y, hspd: parsed_data.hspd, vspd: parsed_data.vspd, random_factor: parsed_data.random_factor})
				}
			}
			break;
			
			case "request_enemy_hurt":
			{
				var _id = parsed_data.connected_id;
				
				with (ENEMY)
				{
					if (_id == connected_id)
					{
						hurt_enemy(self, parsed_data.dir_knock, parsed_data.knock_amt, parsed_data.damage, parsed_data.bonus_atk, false, false);
						break;
					}
				}
			}
			break;
			
			case "enemy_destroy":
			{
				var _id = parsed_data.connected_id;
				
				with (ENEMY)
				{
					if (connected_id == _id)
					{
						instance_destroy();
						break;
					}
				}
			}
			break;
			
			case "add_item":
			{
				global.inventory.addItem(parsed_data.item_id, parsed_data.amt);
			}
			break;
			
			case "destroy_item":
			{
				var _id = parsed_data.connected_id;
				
				with (obj_item)
				{
					if (_id == connected_id)
					{
						instance_destroy();
						break;
					}
				}
			}
			break;
			
			case "create_tile":
			{
				var _x = parsed_data.x;
				var _y = parsed_data.y;
				
				//activate space to check if it is occupied
				instance_activate_region(_x-1, _y-1, 2, 2, true);
				
				//check if space is aleady occupied. If so, replace it.
				var _col = collision_point(_x, _y, TILE, false, true);
				
				if (_col != noone)
					with (_col) instance_destroy();
				
				//Spawn the new tile
				var _t = get_tile_object_from_item(parsed_data.item_id);
				
				if (_t != -1)
					instance_create_layer(parsed_data.x, parsed_data.y, "Instances", _t);
			}
			break;
			
			case "request_create_tile":
			{
				if (global.is_host)
				{
					var _c = collision_point(parsed_data.x, parsed_data.y, OBSTA, false, true);
					
					if (_c == noone)
					{
						instance_create_layer(parsed_data.x, parsed_data.y, "Instances", get_tile_object_from_item(parsed_data.item_id));
					
						//subtract from client inventory
						send_data({cmd: "create_tile_success", item_id: parsed_data.item_id}, async_load[? "id"]);
					}
				}
			}
			break;
			
			case "create_tile_success":
			{
				global.inventory.subtractItem(parsed_data.item_id, 1);
				
				if (instance_exists(obj_player))
					obj_player.client_can_place_tile = true;
			}
			break;
			
			case "world_loaded":
			{
				global.game_state = "PLAY";
			}
			break;
			
			case "request_init_island_markers":
			{
				if (global.is_host)
				{
					//show_debug_message("Islands requested");
					
					//Run mutliplayer init events inside island markers
					with (obj_island_marker)
						event_user(0);
				}
			}
			break;
			
			case "init_island_marker":
			{
				//Load the chunk string
				var _str = parsed_data.chunk_string
				//show_debug_message(_str);
				
				//Create new island marker
				var _i = instance_create_layer(parsed_data.x + global.lag*SCROLL_SPEED, parsed_data.y, "Instances", obj_island_marker, {connected_id: parsed_data.connected_id, chunk_array_heights: parsed_data.heights});
				
				if (_str != "")
				{
					var _g = ds_grid_create(17, 17);
					ds_grid_read(_g, _str);
					
					with (_i)
					{
						//show_debug_message(_g);
						chunk_grid_type = _g;
						event_user(1); //Generate tiles
					}
				}
			}
			break;

			
			case "create_chunk":
			{
				
				//Create new tiles
				if (instance_exists(obj_client_request_chunk))
				{
					obj_chat_box.add("Making chunk");
					instance_create_layer(obj_client_request_chunk.x, WORLD_BOUND_TOP, "Instances", obj_chunk_loader, {tiles: parsed_data.tiles});
					
					with (obj_client_request_chunk)
						instance_destroy();
						
					//Reset scroll_lag
					global.current_tick = parsed_data.tick;
				}
			}
			break;
			
			case "chat": { obj_chat_box.add(parsed_data.text); } break;
			
			default: { show_debug_message("data received: " + parsed_data.cmd); }
		}
		}
		catch (e)
		{
			show_debug_message("Error");
		}
	}
}

function send_enemy_position()
{
	send_data({cmd: "enemy_pos", x: x, y: y, hspd: hspd, vspd: vspd, random_factor: random_factor, connected_id: connected_id, hp: hp, object: object_index});
}