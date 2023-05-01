/// @description Generate Tiles
if (ds_exists(chunk_grid_type, ds_type_grid))
{
	//Prepare chunk_grid_instance for new information
	if (ds_exists(chunk_grid_instance, ds_type_grid))
		ds_grid_clear(chunk_grid_instance, 0);
	else
		chunk_grid_instance = ds_grid_create(17, 17);
	
	//Create instances and store their ids in chunk_grid_instance
	for (var j = 0; j < 17; j++)
	{
		for (var k = 0; k < 17; k++)
		{
			var _t = get_tile_object_from_item(chunk_grid_type[# j, k]);
		
			if (_t != obj_bedrock)
			{
				var _id = instance_create_layer(x + j*16, y + k*16, "Instances", _t);
				chunk_grid_instance[# j, k] = _id;
			}
		}
	}
}