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
	
//Send world seed
if (!global.is_host && global.world_seed = -1 && global.multiplayer && current_time mod 10 == 0)
{
	send_data({cmd: "request_world_seed"});
	show_debug_message("requesting seed");
}

//Enemy spawning
if (instance_exists(obj_player) && (room == Room1 || room == rm_small) && global.is_host && instance_number(ENEMY) < 15)
{	
	var _p = irandom(instance_number(PLAYER)-1);
	var player = instance_find(PLAYER, _p);
	var _y = player.y;
	var _x = player.x;
	
	if (enemy_spawn_delay <= 0)
	{
		enemy_spawn_delay = 60*60*irandom_range(1,2);
		instance_create_layer(_x, _y-CHUNK_HEIGHT*2, "Instances", obj_vector_weevil);
	}
	else enemy_spawn_delay--;
	
	//Other
	var _r = irandom(99999);
	
	if (_r > 0 && _r < 80)
		instance_create_layer(random_range(_x - CHUNK_WIDTH/2, _x + CHUNK_WIDTH/2), room_height-100, "Instances", obj_balloonimal);
}

if (instance_exists(obj_island_generator) || instance_exists(obj_ore_generator))
{
	draw_enable_drawevent(false);
	
	load_timer++;
	
	if (load_timer >= 5)
	{
		load_timer = 0;
		draw_enable_drawevent(true);
	}
	//show_debug_message(instance_number(obj_island_generator));
} 
else if (loading_world && (room == Room1 || room == rm_small || room == rm_large))
{
	loading_world = false;
	with camera event_user(0);
	draw_enable_drawevent(true);
	
	//Spawn sound
	audio_play_sound(snd_entered_empyrious, 10, false);
	
	//Spawn player
	//TODO: load player data into networkingControl as a struct and then pass it into the object here:
	instance_create_layer(obj_market.x, obj_market.y, "Instances", obj_player);
}

