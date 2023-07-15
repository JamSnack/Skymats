/// @description Insert description here
// You can write your code in this editor
depth = -1;
mask_index = spr_player_idle;


hmove = 0;
max_walkspeed = 3;
position_update_delay = 10;
client_can_place_tile = true;
gold = 0;

//Grappling
grapple_point_x = 0;
grapple_point_y = 0;
grapple_target_point_x = 0;
grapple_target_point_y = 0;
grappling = false;
grapple_is_launching = false;
grapple_launch_length = 0;
false_angle = image_angle;
grapple_direction = 0;
draw_angle = 0;
mask_index = spr_player;
grappling_to = noone;

//Mine
mine_cooldown = 0;
mine_surface = noone;
mine_laser_distance = 0;
mine_laser_direction = 0;

//Animation
jetpack_fuel_draw = 0;

//init upgrades purchased list
upgrades_purchased = array_create(UPGRADE.last, 1);

username = networkingControl.username;
init_player_stats();

//load_character(networkingControl.character_file);

init_player();
calculate_player_level();

//obj_chat_box.add("Welcome to " + string(room_get_name(room)) + "!");

//Sync chunks
//if (!global.is_host && global.multiplayer)
	//sync_chunks();

dead = false;
respawn_delay = 60;
can_hurt = true;
can_hurt_delay = 0;
_tile = noone;
hurt_effect = 0;

//Combat stuff
enemy_hurt_list = ds_list_create();
enemy_hurt_list_mining = ds_list_create();

//Healthbar animation
draw_hp = 0;
draw_hp_red = 0;

//Spawn in tutorial if not complete
if (global.tutorial_complete != true)
{
	x = 30;
	y = 120;
	
	global.platform_height = 0;
	global.can_grapple = false;
	global.can_jetpack = false;
	
	//save_game();
} else y = global.platform_height;