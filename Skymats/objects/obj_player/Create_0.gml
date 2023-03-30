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
stat_grapple_range = 160; //How far the hook can go (600 is about the edge of the screen) +20

//- mining tool
stat_mine_level = 1; //Determines which blocks can be destroyed and not
stat_mine_cooldown = 30; //Determines how much time must pass before the pickaxe can be swung again

//- jetpack
stat_jetpack_fuel = 120; //How many frames can pass before the jetpack runs out of fuel.
stat_jetpack_strength = 0.2; //How fast the jetpack boosts you
stat_jetpack_cooldown = 60; //How many frames of inactivity need to pass before the jetpack fuel begins regenerating
stat_jetpack_regen_rate = 0.3; //How much jetpack fuel regenerates each frame.

jetpack_fuel = stat_jetpack_fuel;
jetpack_regen_cooldown = stat_jetpack_cooldown;
jetpack_set_init_delay = 15; 
jetpack_init_delay = jetpack_set_init_delay; //How long it takes for the jetpack to be usable after leaving the ground

//- weapon
stat_weapon_cooldown = 90; //How many frames it takes to prepare the auto-attack
stat_weapon_damage = 1;
stat_weapon_knockback = 6;
stat_weapon_range = 28;

weapon_cooldown = stat_weapon_cooldown;


//init upgrades purchased list
upgrades_purchased = array_create(UPGRADE.last, 1);
