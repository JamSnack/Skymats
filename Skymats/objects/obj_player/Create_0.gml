/// @description Insert description here
// You can write your code in this editor

max_walkspeed = 2;

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
stat_grapple_force = 0.5; //How much force is applied to the player
stat_grapple_speed = 12; //How fast the hook travels
stat_grapple_range = 240; //How far the hook can go (600 is about the edge of the screen)

//- mining tool
stat_mine_level = 1; //Determines which blocks can be destroyed and not
stat_mine_cooldown = 30; //Determines how much time must pass before the pickaxe can be swung again

//- jetpack