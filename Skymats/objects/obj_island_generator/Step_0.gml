var column_height = height;
y += 16 * choose(0, 0, 0, 0, 0, 1, 1, -1, -1, 2, -2);
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
	var _c = collision_point(current_x, current_y + 16*i, TILE, false, true);
	
	if (_c == noone)
	{
	
		//select tile type to place
		var _obj = obj_grass;
	
		if (irandom(2) + i > 4)
			_obj = obj_stone;
	
		//place tile
		instance_create_layer(current_x, current_y + 16*i, "Instances", _obj);
	
		if (cutoff_start == 0 && cutoff_end == 0 && irandom(60) == 3 && (current_y + 16*i) > 7 )
		{
			var chosen_ore = choose_ore(current_y);
			instance_create_layer(current_x, current_y + 16*i, "Instances", obj_ore_generator, {ore_to_generate: get_tile_object_from_item(chosen_ore)});
		}
	}
}

//increase time
time++;

//The island is complete
if (time > width)
	instance_destroy();