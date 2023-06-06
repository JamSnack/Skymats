/// @description Insert description here
// You can write your code in this editor
if (alarm[0] == -1)
{
	if (ds_list_size(inst_list) <= 0)
	{
		global.dungeon = false;
	
		if (instance_exists(obj_platform))
			obj_platform.fuel = obj_platform.max_fuel;
		
		instance_destroy();
	}
	else
	{
		if (!instance_exists(inst_list[| check_index]))
			ds_list_delete(inst_list, check_index);

		if (check_index+1 < number_of_watching)
			check_index++;
		else check_index = 0;
	}
}