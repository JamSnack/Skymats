/// @description Insert description here
// You can write your code in this editor
if (alarm[0] == -1)
{
	if (number_of_watching <= 0)
	{
		global.dungeon = false;
	
		with (obj_platform)
		{
			fuel = max_fuel;
			approach_dungeon = true;
			
			while(collision_line(x, y, x, global.platform_height, OBSTA, false, true) != noone)
			{
				with (collision_line(x, y, x, global.platform_height, OBSTA, false, true))
				{
					create_sprite_shatter(x, y, 3, sprite_index, 3, 270, 0.1);
					instance_destroy();
				}
			}
		}
		
		with (obj_item)
			big_suck = true;
		
		instance_destroy();
		
		//TODO: If next_dungeon then:
			//init_dungeon_load();
			//load_dungeon("temp_dungeon");
		//else:
		instance_create_layer(room_width/2, WORLD_BOUND_TOP - 54, "Instances", obj_dungeon_dock_point);
		
		show_debug_message("Dungeon cleared!");
	}
	else
	{
		if (inst_list[| check_index] != noone && !instance_exists(inst_list[| check_index]))
		{
			number_of_watching -= 1;
			inst_list[| check_index] = noone;
		}

		if (check_index+1 < ds_list_size(inst_list))
			check_index++;
		else check_index = 0;
	}
}