/// @description Insert description here
// You can write your code in this editor

with (obj_dungeon_clear_condition)
	ds_list_add(other.save_list, id);

with (NOCOL)
	ds_list_add(other.save_list, id);

with (TILE)
	ds_list_add(other.save_list, id);
	
with (obj_dungeon_dock_point)
	ds_list_add(other.save_list, id);
	
with (ENEMY)
	ds_list_add(other.save_list, id);

//save_dungeon(get_string("Enter Dungeon Name: ", "Dungeon"), save_list);
save_dungeon("temp_dungeon", save_list, next_dungeon);