/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if (ds_exists(enemy_hurt_list, ds_type_list))
	ds_list_destroy(enemy_hurt_list);
	
if (ds_exists(enemy_hurt_list_mining, ds_type_list))
	ds_list_destroy(enemy_hurt_list_mining);

