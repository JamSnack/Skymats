/// @description Insert description here
// You can write your code in this editor
//random_set_seed(global.world_seed + x + y);
if (!global.is_host)
{
	instance_destroy();
	exit;
}
else
{
	marker_object = instance_create_layer(x + 5*16, y - 16*4, "Instances", obj_island_marker);
}

time = 0;
cutoff_start = floor(width/choose(4,5,6));
cutoff_end = 0;


	
//Island grid
chunk_grid_type = ds_grid_create(width+1, height+1);
chunk_array_heights = array_create(width+1, 0);
chunk_grid_instance = ds_grid_create(width+1, height+1);