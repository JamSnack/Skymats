/// @description Insert description here
// You can write your code in this editor
if (global.multiplayer == false && keyboard_check_released(vk_f1))
{
	event_user(0);
	//room_goto(Room1);
}

//Send client id
if (!global.is_host && global.client_id == -1 && global.multiplayer && current_time mod 4 == 0)
	send_data({cmd: "request_client_id"});

if (loading_world && (room == Room1 || room == rm_small || room == rm_large))
{
	loading_world = false;
	draw_enable_drawevent(true);
	
	//Spawn sound
	audio_play_sound(snd_entered_empyrious, 10, false);
	
	//Spawn player
	//TODO: load player data into networkingControl as a struct and then pass it into the object here:
	instance_create_layer(obj_market.x, obj_market.y, "Instances", obj_player);
}

//multiplayer
if (global.multiplayer)
{
	network_timeout--;
	
	if (network_timeout <= 0)
	{
		global.multiplayer = false;
		global.is_host = true;
		//TODO: cleanup server stuff
		
		obj_chat_box.add("Timed out!");
	}
	
	global.current_tick++;
}

