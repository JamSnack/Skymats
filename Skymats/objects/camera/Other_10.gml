/// @description Deactivate Tiles
last_chunk_x = x;
last_chunk_y = y;

//Deactivate all tiles
if (!instance_exists(obj_multiplayer_world_loader))
	instance_deactivate_object(TILE);
		
//Reactivate tiles around the player
var _boundary = boundary_size*2;
instance_activate_region(last_chunk_x-_boundary, last_chunk_y-_boundary, _boundary*2, _boundary*2, true);

//instance_activate_object(obj_pot_of_greed);

//Keep enemies outside of newely-activated tiles
with (ENEMY)
{
	if (object_index == obj_greed_collector)
		continue;
		
	if (collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, TILE, false, true) != noone)
	{
		while (collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, TILE, false, true) != noone)
		{
			y -= 2;	
		}
	}
}