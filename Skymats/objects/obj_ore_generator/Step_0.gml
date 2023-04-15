if (instance_exists(obj_island_generator))
	exit;

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
			instance_create_layer(x, y, "Instances", other.ore_to_generate);
			instance_destroy();
		}
			
		prev_x = _inst.x;
		prev_y = _inst.y;
	}
}
else time = ore_to_generate;


//Kill
time++;

if (time >= ore_amount)
	instance_destroy();
