//if (global.world_seed == -1)
//	exit;

var column_height = height;
var offset = 16 * choose(0, 0, 0, 0, 0, 1, 1, -1, -1, 2, -2)*variance_factor;
y += offset;

chunk_array_heights[time] = offset;

var current_y = y;
var current_x = x + 16*time;

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
	
	//select tile type to place
	var _obj = obj_grass;
	
	if (irandom(2) + i > 4)
		_obj = obj_stone;
	
	//place tile
	var _id = instance_create_layer(current_x, current_y + 16*i, "Instances", _obj, {owner: marker_object.id, grid_pos: {x: time, y: i}});
	ds_grid_add(chunk_grid_type, time, i, _obj.item_id);
	ds_grid_add(chunk_grid_instance, time, i, _id);
}

//increase time
time++;

//The island is complete
if (time > width)
{
	var veins = 2 + irandom(3) + floor(global.platform_height/5000)*5000;
	var count = 0;

	//Guaranteed ore spawn
	repeat(veins)
	{
		var chosen_ore = choose_ore(current_y); //TODO: Figure out how to utilize count here
		var prev_x = x + 16*irandom(width-1);
		var prev_y = y + 16*4 + 16*irandom(height-4);
		var ore_amount = 3 + irandom(3);
			
		repeat(ore_amount)
		{
			if (instance_exists(obj_stone))
			{
				//Look to infect, if none, go to nearest stone
				var _inst = tile_is_adjacent(prev_x, prev_y, obj_stone);
	
				if (_inst == noone)
					_inst = instance_nearest(prev_x, prev_y, obj_stone);
	
				//If we have an instance, infect the stone
				if (_inst != noone)
				{
					with (_inst)
					{
						var _ore = instance_create_layer(x, y, "Instances", get_tile_object_from_item(chosen_ore), {owner: owner, grid_pos: {x: grid_pos.x, y: grid_pos.y}});
						other.chunk_grid_type[# grid_pos.x, grid_pos.y] = chosen_ore;
						other.chunk_grid_instance[# grid_pos.x, grid_pos.y] = _ore;
						instance_destroy();
					}
			
					prev_x = _inst.x;
					prev_y = _inst.y;
				}
			}
		}
	}

	//Destroy generator
	instance_destroy();

	//Hand off ownership of the grids
	marker_object.chunk_grid_type = chunk_grid_type;
	marker_object.chunk_grid_instance = chunk_grid_instance;
	marker_object.chunk_array_heights = chunk_array_heights;
	chunk_grid_type = -1;
	chunk_grid_instance = -1;
	chunk_array_heights = -1;
	
	//send new island to clients
	with (marker_object) event_user(0);
	
	//Create a greenthin
	instance_create_layer(marker_object.x, marker_object.y, "Instances", obj_greenthin);
	
	//for (var i = 0; i < width; i++)
	//{
	//	show_debug_message(chunk_grid[# width, i]);
	//}
}