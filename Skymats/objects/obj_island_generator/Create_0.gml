/// @description Insert description here
// You can write your code in this editor
//random_set_seed(global.world_seed + x + y);
time = 0;
cutoff_start = floor(width/choose(4,5,6));
cutoff_end = 0;

if (!global.is_host)
	instance_destroy();