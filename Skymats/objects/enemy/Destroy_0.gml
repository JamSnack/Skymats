/// @description Insert description here
// You can write your code in this editor
if (global.is_host)
	send_data({cmd: "enemy_destroy", connected_id: connected_id});


ds_list_add(global.recently_destroyed_list, connected_id);