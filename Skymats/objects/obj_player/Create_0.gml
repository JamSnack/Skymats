/// @description Insert description here
// You can write your code in this editor
depth = -1;

hmove = 0;
max_walkspeed = 3;
position_update_delay = 10;
client_can_place_tile = true;
gold = 99999;

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
stat_jetpack_fuel = 50; //How many frames can pass before the jetpack runs out of fuel. +30
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
