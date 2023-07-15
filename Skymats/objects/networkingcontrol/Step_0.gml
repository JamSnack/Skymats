/// @description Insert description here
// You can write your code in this editor
if (global.multiplayer == false)
{
	if (keyboard_check_released(vk_f1))
		event_user(0);
	else if (keyboard_check_released(vk_f2))
		event_user(1);
}

if (room == rm_small && !instance_exists(obj_player))
	instance_create_layer(room_width/2, global.platform_height+900, "Instances", obj_player);


//Send client id
//if (!global.is_host && global.client_id == -1 && global.multiplayer && current_time mod 4 == 0)
//	send_data({cmd: "request_client_id"});

//multiplayer
if (global.multiplayer)
{
	if (!global.is_host)
	{
		network_timeout--;
		
		//request client_id
		if (global.client_id == -1)
		{
			send_data({cmd: "request_client_id"});
			show_debug_message("requesting client id");
		}
	
		if (network_timeout <= 0)
		{
			show_debug_message("Client timed out.");
			global.multiplayer = false;
			global.is_host = true;
			global.client_id = -1;
			
			if (global.host_socket != -1)
				network_destroy(global.host_socket);
				
			global.host_socket = -1;
		
			//Load previous expedition
			//load_expedition(exped_name+".exped");
		
			obj_chat_box.add("Lost connection with host. Returning to solo expedition!");
		
			//Delete lingering players
			with (obj_player_dummy)
				instance_destroy();
			
			//Reset player Y
			with (obj_player)
				y = global.platform_height;
			
			//reset network timeout
			network_timeout = 60*10;
			
		}
	}
	
	global.current_tick++;
}

