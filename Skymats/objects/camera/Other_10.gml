/// @description Deactivate Tiles
if (instance_exists(obj_island_generator) || instance_exists(obj_ore_generator))
	exit;

last_chunk_x = x;
last_chunk_y = y;

//Deactivate all tiles
if (!instance_exists(obj_multiplayer_world_loader))
	instance_deactivate_object(TILE);
		
//Reactivate tiles around the player
var _boundary = boundary_size*2;
instance_activate_region(last_chunk_x-_boundary, last_chunk_y-_boundary, _boundary*2, _boundary*2, true);
