/// @description Insert description here
// You can write your code in this editor
if (global.is_host)
{
	send_data({cmd: "enemy_destroy", connected_id: connected_id});
	
	/*
	if (drop_item && item_to_drop != ITEM_ID.last)
		instance_create_layer(x, y, "Instances", obj_item, {item_id: item_to_drop});
	*/
}

if (global.multiplayer)
	ds_list_add(global.recently_destroyed_list, connected_id);

//Enemies drop cash instead of items
if (drop_item && cash_to_drop > 0)
{
	instance_create_layer(x, y, "Instances", obj_item, {item_id: ITEM_ID.cash, cash_value: cash_to_drop });
	
	with(obj_player)
		jetpack_fuel += stat_jetpack_fuel*0.13;
}