/// @description Generate Tiles

for (var j = 0; j < 17; j++)
{
	for (var k = 0; k < 17; k++)
	{
		var _t = get_tile_object_from_item(chunk_grid[# j, k]);
		
		if (_t != obj_bedrock)
			instance_create_layer(x + j*16, y + k*16, "Instances", _t);
	}
}
