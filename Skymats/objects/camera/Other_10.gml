/// @description Deactivate Tiles
last_chunk_x = x;
last_chunk_y = y;

//Deactivate all tiles
instance_deactivate_object(TILE);
		
//Reactivate tiles around the player
var _boundary = boundary_size*2;
instance_activate_region(last_chunk_x-_boundary, last_chunk_y-_boundary, _boundary*2, _boundary*2, true);
		
//This should happen because we just deactivated all tiles and we need to make sure enemies don't clip into things
/*if (global.is_host == true)
{
	with (ENEMY)
	{
		instance_activate_region(x-_boundary/4, y-_boundary/4, _boundary/2, _boundary/2, true);
	}
}*/
