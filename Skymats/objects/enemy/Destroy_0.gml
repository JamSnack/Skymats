/// @description Insert description here
// You can write your code in this editor
if (global.is_host)
{
	send_data({cmd: "enemy_destroy", connected_id: connected_id});
	
	if (drop_item && item_to_drop != ITEM_ID.last)
		instance_create_layer(x, y, "Instances", obj_item, {item_id: item_to_drop});
}


ds_list_add(global.recently_destroyed_list, connected_id);