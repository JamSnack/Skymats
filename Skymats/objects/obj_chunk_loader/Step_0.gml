/// @description Insert description here
// You can write your code in this editor
//stuff
var _a = tiles_size//(instant == true) ? tiles_size : 10
repeat(_a)
{
	if (time < tiles_size)
	{
		var _t = tiles[time++];
		
		//If the space is already occupied by a tile, check to see if it is the same tile. If it is, do nothing, else destroy it and create a new one. If a tile is not here, create a new one
		var _c = collision_point(_t.x+x, _t.y, TILE, false, true);
		var same_tile = false;
		
		if (_c != noone)
		{
			if (_c.item_id != _t.item_id)
				with _c instance_destroy();
			else same_tile = true;
		}
	
		//create new tile
		if (!same_tile)
			instance_create_layer(x+_t.x, _t.y, "Instances", get_tile_object_from_item(_t.item_id));
	}
	else 
	{
		instance_destroy();
		break;
	}
	
}

x += SCROLL_SPEED;