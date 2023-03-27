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
	}
	else
	{
		//Fail
		show_debug_message("Failed to connect to server");
	}
}

function send_data(data_struct, specific_socket = -1)
{
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
	var parsed_data = json_parse(data);
	//show_debug_message("Handling data: "+string(data));
	
	if (parsed_data != -1)
	{
		switch parsed_data.cmd
		{	
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
					global.client_id = parsed_data.client_id;
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
								send_data(parsed_data);
								
							break;
						}
					}
					
					if (create_new)
						instance_create_layer(_x, _y, "Instances", obj_player_dummy, {connected_id: _id})	
				}
			}
			break;
			
			case "destroy_tile":
			{
				var _x = parsed_data.x;
				var _y = parsed_data.y;
				
				instance_activate_region(_x-1, _y-1, 2, 2, true);
				
				var _c = collision_point(_x, _y, TILE, false, true);
				
				if (_c != noone)
					with _c instance_destroy();
			}
			break;
			
			case "request_tile_hit":
			{
				if (global.is_host)
				{
					var _x = parsed_data.x;
					var _y = parsed_data.y;
				
					instance_activate_region(_x-1, _y-1, 2, 2, true);
				
					var _c = collision_point(_x, _y, TILE, false, true);
					
					if (_c != noone)
					{
						with _c 
						{	
							instance_destroy();
							event_user(0);
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
					instance_create_layer(_x, _y, "Instances", obj_item, {connected_id: _id, image_index: _item_id, item_id: _item_id})	
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
						create_new = false;
							
						//Break
						break;
					}
				}
					
				if (create_new)
					instance_create_layer(_x, _y, "Instances", ENEMY, {connected_id: _id})
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
			
			default: { show_debug_message("data received: " + parsed_data.cmd); }
		}
	}
}