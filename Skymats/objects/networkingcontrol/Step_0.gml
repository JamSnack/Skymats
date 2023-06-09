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
if (!global.is_host && global.client_id == -1 && global.multiplayer && current_time mod 4 == 0)
	send_data({cmd: "request_client_id"});

//multiplayer
if (global.multiplayer)
{
	//network_timeout--;
	
	if (network_timeout <= 0)
	{
		global.multiplayer = false;
		global.is_host = true;
		//TODO: cleanup server stuff
		
		obj_chat_box.add("Timed out!");
	}
	
	global.current_tick++;
}

