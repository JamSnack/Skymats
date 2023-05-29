// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
global.background_particles = part_system_create();
part_system_depth(global.background_particles, 96);

global.foreground_particles = part_system_create();
part_system_depth(global.foreground_particles, -2);

var p_foreground_cloud = part_type_create();
part_type_alpha1(p_foreground_cloud, 1);
part_type_sprite(p_foreground_cloud, spr_foreground_clouds, false, false, true);
part_type_direction(p_foreground_cloud, 0, 0, 0, 0);
part_type_speed(p_foreground_cloud, SCROLL_SPEED + 0.05, SCROLL_SPEED + 0.25, 0, 0);
//part_type_speed(p_foreground_cloud, 3, 3, 0, 0);
part_type_life(p_foreground_cloud, (300+1366)/(SCROLL_SPEED + 0.05), (300+1366)/(SCROLL_SPEED + 0.05) + 10);

var p_background_cloud1 = part_type_create();
part_type_alpha1(p_background_cloud1, 1);
part_type_sprite(p_background_cloud1, spr_background_clouds, false, false, true);
part_type_scale(p_background_cloud1, 0.75, 0.75);
part_type_direction(p_background_cloud1, 0, 0, 0, 0);
//part_type_speed(p_background_cloud1, 3, 3, 0, 0);
part_type_speed(p_background_cloud1, SCROLL_SPEED/3, SCROLL_SPEED/3 + 0.05, 0, 0);
part_type_life(p_background_cloud1, (300+1366)/(SCROLL_SPEED/3), (300+1366)/(SCROLL_SPEED/3) + 10);

var p_background_islands1 = part_type_create();
part_type_alpha1(p_background_islands1, 0.5);
part_type_sprite(p_background_islands1, spr_background_islands, false, false, true);
part_type_scale(p_background_islands1, 0.4, 0.4);
part_type_direction(p_background_islands1, 0, 0, 0, 0);
//part_type_speed(p_background_cloud1, 3, 3, 0, 0);
part_type_speed(p_background_islands1, SCROLL_SPEED/3, SCROLL_SPEED/3 + 0.05, 0, 0);
part_type_life(p_background_islands1, (300+1366)/(SCROLL_SPEED/3), (300+1366)/(SCROLL_SPEED/3) + 10);

global.particle_library =
{
	foreground_cloud : p_foreground_cloud,
	background_cloud1 : p_background_cloud1,
	background_islands1: p_background_islands1
}
