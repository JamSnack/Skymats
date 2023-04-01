/// @description Insert description here
// You can write your code in this editor

time=0;
tiles_size = array_length(tiles);

//Activate instances in advance
instance_activate_region(x, y, CHUNK_WIDTH, CHUNK_HEIGHT, true);

//Overrwrite other chunkers
var _c = instance_nearest(x, y, obj_chunk_loader);

if (distance_to_object(_c) <= 1)
	with _c instance_destroy();