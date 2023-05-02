//if (global.world_seed == -1)
//	exit;

var column_height = height;
var offset = 16 * choose(0, 0, 0, 0, 0, 1, 1, -1, -1, 2, -2)*variance_factor;
y += offset;

chunk_array_heights[time] = offset;

var current_y = y;
var current_x = x + 16*time;

//Ensure we remain on the world seed.
random_set_seed(global.world_seed + current_x + current_y);

//Taper ends
if (time < width/2 && cutoff_start > 0)
{
	column_height -= cutoff_start;
	cutoff_start = approach(cutoff_start, 0, irandom(3));
}
else if (time > (width/3)*2)
{
	column_height -= cutoff_end;
	cutoff_end = approach(cutoff_end, height-6, irandom(3));
}

//create an island, column-by-column
for (var i = 0; i < column_height; i++)
{	
	//If the player is move up incredibly fast, the island which is being generated can be destroyed (its marker along with it), but this object may still assume the marker exists.
	if (!instance_exists(marker_object))
	{
		instance_destroy();
		break;
	}
	
	var _c = collision_point(current_x, current_y + 16*i, TILE, false, true);
	
	if (_c == noone)
	{
	
		//select tile type to place
		var _obj = obj_grass;
	
		if (irandom(2) + i > 4)
			_obj = obj_stone;
	
		//place tile
		var _id = instance_create_layer(current_x, current_y + 16*i, "Instances", _obj, {owner: marker_object.id, grid_pos: {x: time, y: i}});
		ds_grid_add(chunk_grid_type, time, i, _obj.item_id);
		ds_grid_add(chunk_grid_instance, time, i, _id);
	
		//if (cutoff_start == 0 && cutoff_end == 0 && irandom(50) == 3 )
		//{
			//var chosen_ore = choose_ore(current_y);
			//instance_create_layer(current_x, current_y + 16*i, "Instances", obj_ore_generator, {ore_to_generate: get_tile_object_from_item(chosen_ore)});
		//}
	}
}

//increase time
time++;

//The island is complete
if (time > width)
{
	//Guaranteed ore spawn
	//var chosen_ore = choose_ore(current_y);
	//instance_create_layer(current_x, current_y + 16*i, "Instances", obj_ore_generator, {ore_to_generate: get_tile_object_from_item(chosen_ore)});
	instance_destroy();

	//Hand off ownership of the grids
	marker_object.chunk_grid_type = chunk_grid_type;
	marker_object.chunk_grid_instance = chunk_grid_instance;
	marker_object.chunk_array_heights = chunk_array_heights;
	chunk_grid_type = -1;
	chunk_grid_instance = -1;
	chunk_array_heights = -1;
	
	//for (var i = 0; i < width; i++)
	//{
	//	show_debug_message(chunk_grid[# width, i]);
	//}
}