/// @description Insert description here
// You can write your code in this editor

if (global.is_host && instance_exists(owner))
{
	send_data({cmd: "destroy_tile", x: grid_pos.x, y: grid_pos.y, owner_id: owner.connected_id});
}

//global.tiles_list.remove(id);

if (instance_exists(owner) && ds_exists(owner.chunk_grid_type, ds_type_grid) && grid_pos != noone)
{
	owner.chunk_grid_type[# grid_pos.x, grid_pos.y] = 0;
}

if (layer_sprite_exists("Shadows", shadow))
	layer_sprite_destroy(shadow);