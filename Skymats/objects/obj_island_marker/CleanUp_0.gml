/// @description Insert description here
// You can write your code in this editor

if (ds_exists(chunk_grid_type, ds_type_grid))
	ds_grid_destroy(chunk_grid_type);
	
if (ds_exists(chunk_grid_instance, ds_type_grid))
	ds_grid_destroy(chunk_grid_instance);