/// @description Insert description here
// You can write your code in this editor
depth = -1;

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

//Stats

//- grapple
stat_grapple_force = 0.25; //How much force is applied to the player +0.5
stat_grapple_speed = 6; //How fast the hook travels +2
stat_grapple_range = 100; //How far the hook can go (600 is about the edge of the screen) +20

//- mining tool
stat_mine_level = 1; //Determines which blocks can be destroyed and not
stat_mine_cooldown = 45; //Determines how much time must pass before the pickaxe can be swung again

//- jetpack
stat_jetpack_fuel = 70; //How many frames can pass before the jetpack runs out of fuel. +30
stat_jetpack_strength = 0.15; //How fast the jetpack boosts you + 0.025
stat_jetpack_cooldown = 90; //How many frames of inactivity need to pass before the jetpack fuel begins regenerating -10
stat_jetpack_regen_rate = 0.2; //How much jetpack fuel regenerates each frame. +0.05

//- weapon
stat_weapon_cooldown = 100; //How many frames it takes to prepare the auto-attack
stat_weapon_damage = 1;
stat_weapon_knockback = 6;
stat_weapon_range = 28;

init_player();

//init upgrades purchased list
upgrades_purchased = array_create(UPGRADE.last, 1);
username = "";

//Load-game
if (file_exists("test.data"))
{
	var _buff = buffer_load("test.data");	
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
		
		//Platform
		global.platform_height = _data.platform_height;
	}
	catch (e)
	{
		show_debug_message("Error loading file");
		show_debug_message(e);
	}
}

obj_chat_box.add("Welcome to " + string(room_get_name(room)) + "!");

//Sync chunks
//if (!global.is_host && global.multiplayer)
	//sync_chunks();

dead = false;
respawn_delay = 60;