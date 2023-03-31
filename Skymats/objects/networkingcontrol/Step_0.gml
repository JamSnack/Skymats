/// @description Insert description here
// You can write your code in this editor

if (room == Room2)
{
	if (keyboard_check_released(vk_numpad1))
	{
		loading_world = true;
		event_user(0);
		room_goto(rm_small);
	}
	else if (keyboard_check_released(vk_numpad2))
	{
		loading_world = true;
		event_user(1);
		room_goto(rm_small);
	}
}
else
{
	if (!global.is_host && global.client_id == -1 && global.multiplayer && current_time mod 4 == 0)
		send_data({cmd: "request_client_id"});
}

//Enemy spawning
if ((room == Room1 || room == rm_small) && global.is_host)
{
	if (enemy_spawn_delay <= 0)
	{
		enemy_spawn_delay = 60*60*irandom_range(1,2);
		instance_create_layer(0, room_height-100, "Instances", obj_vector_weevil);
	}
	else enemy_spawn_delay--;
	
	//Other
	var _r = irandom(99999);
	
	if (_r > 0 && _r < 80)
		instance_create_layer(random(room_width), room_height-100, "Instances", obj_balloonimal);
}

if (instance_exists(obj_island_generator) || instance_exists(obj_ore_generator))
{
	draw_enable_drawevent(false);
	//show_debug_message(instance_number(obj_island_generator));
} 
else if (loading_world && (room == Room1 || room == rm_small))
{
	loading_world = false;
	with camera event_user(0);
	draw_enable_drawevent(true);
	
	//Spawn sound
	audio_play_sound(snd_entered_empyrious, 10, false);
}