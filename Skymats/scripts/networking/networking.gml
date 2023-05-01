// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function connect_to_server(ip, port)
{
	//server_status = "Connecting to server...";
	global.host_socket = network_create_socket(network_socket_tcp);
	
	//Try to connect to the main server. If we fail, look for a server over local host.
	var _s = network_connect(global.host_socket, ip, port);
	
	if (_s >= 0)
	{
		//Success
		show_debug_message("Connected to server");
		global.multiplayer = true;
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

function handle_data(data)
{	
	try
	{
		var parsed_data = json_parse(data);
	}
	catch (e)
	{
		show_debug_message(e);
		return false;	
	}
	//show_debug_message("Handling data: "+string(data));
	if (!global.is_host)
	{
		global.lag = global.current_tick - parsed_data.tick;
	}
	
	if (parsed_data != -1)
	{
		switch parsed_data.cmd
		{	
			
			case "sync_platform":
			{
				global.platform_height = parsed_data.height;
				
				if (instance_exists(obj_platform))
				{
					with (obj_platform)
					{
						target_y = parsed_data.target;
						powered = parsed_data.powered;
						obstruction = parsed_data.obstructed;
						fuel = parsed_data.fuel
						max_fuel = parsed_data.max_fuel;
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
				}
			}
			break;
			
			case "desync_detected":
			{
				
				if (!global.is_host)
				{
					obj_chat_box.add("Loading new chunk");
					var _x = parsed_data.x;
					var _y = parsed_data.y;
					
					instance_create_layer(_x, _y, "Instances", obj_client_request_chunk);
					
					//Erase old chunk
					while (collision_rectangle(_x, _y, _x+CHUNK_WIDTH, _y+CHUNK_HEIGHT, TILE, false, true))
					{
						with collision_rectangle(_x, _y, _x+CHUNK_WIDTH, _y+CHUNK_HEIGHT, TILE, false, true)
							instance_destroy();
					}
				}
			}
			break;
			
			//case "request_world_seed": { send_data({ cmd: "give_world_seed", seed: global.world_seed}); }
			case "request_world_seed": { send_data({ cmd: "give_world_list", list: global.tiles_list.to_string(), size: global.tiles_list.tiles_list_size}); }
			break;
			
			/*case "give_world_seed": { 
				if (global.world_seed == -1) global.world_seed = parsed_data.seed;
				show_debug_message("Seed is:");
				show_debug_message(parsed_data.seed);
				} 
			break;*/
			
			case "give_world_list": 
			{ 
				/*global.world_seed = noone;
				//ds_list_clear(global.tiles_list);
				var tiles = json_parse(parsed_data.list);
				
				for (var _i = 0; _i < parsed_data.size; _i++)
				{
					var _t = tiles.list[_i];
					instance_create_layer(_t[2], _t[3], "Instances", get_tile_object_from_item(_t[1]));
				}*/
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
				/*
				var _x = parsed_data.x + global.lag*SCROLL_SPEED;
				var _y = parsed_data.y;
				
				instance_activate_region(_x-1, _y-1, 2, 2, true);
				
				instance_create_layer(_x, _y, "Instances", obj_tile_breaker, {damage: 999});
				*/
				
				//var marker_id = parsed_data.marker_id;
				
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
			
			case "request_tile_hit":
			{
				if (global.is_host)
				{
					var _x = parsed_data.x;
					var _y = parsed_data.y;
				
					instance_activate_region(_x-1, _y-1, 2, 2, true);
				
					instance_create_layer(_x, _y, "Instances", obj_tile_breaker, {damage: parsed_data.damage, drop_item: true, connected_socket: async_load[? "id"]});
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
				
				with (ENEMY)
				{
					if (_id == connected_id)
					{
						target_x = _x;
						target_y = _y;
						hp = parsed_data.hp;
						create_new = false;
							
						//Break
						break;
					}
				}
					
				if (create_new)
					instance_create_layer(_x, _y, "Instances", parsed_data.object, {connected_id: _id, target_x: _x, target_y: _y})
			}
			break;
			
			case "request_enemy_hurt":
			{
				var _id = parsed_data.connected_id;
				
				with (ENEMY)
				{
					if (_id == connected_id)
					{
						hurt_enemy(self, parsed_data.dir_knock, parsed_data.knock_amt, parsed_data.damage);
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
				global.inventory.addItem("", parsed_data.item_id, parsed_data.amt);
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
					show_debug_message("Islands requested");
					//var _r = instance_nearest(parsed_data.x, parsed_data.y, obj_multiplayer_world_loader);
					
					//If the world loader requested doesn't exist or one does exist but it is far away:
					//if ((_r != noone && point_distance(parsed_data.x, parsed_data.y, _r.x, _r.y) > 1) || _r == noone)
					//{
					//show_debug_message(parsed_data.x);
					//show_debug_message(parsed_data.y);
					//instance_create_layer(parsed_data.x, parsed_data.y, "Instances", obj_multiplayer_world_loader, {target_socket: async_load[? "id"], single_chunk: true});	
					//instance_create_layer(0, WORLD_BOUND_TOP, "Instances", obj_multiplayer_world_loader, {target_socket: async_load[? "id"], single_chunk: true});	
					//}
					
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
				show_debug_message(_str);
				
				//Create new island marker
				var _i = instance_create_layer(parsed_data.x + global.lag*SCROLL_SPEED, parsed_data.y, "Instances", obj_island_marker, {connected_id: parsed_data.connected_id});
				
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
			
			case "chunk_sent":
			{
				//var _r = instance_nearest(parsed_data.x, parsed_data.y, obj_client_request_chunk);
				
				//if (_r != noone && point_distance(0, 0, _r.x, _r.y) <= 1)
				//	with _r instance_destroy();
				
				//with (obj_client_request_chunk) instance_destroy();
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
}