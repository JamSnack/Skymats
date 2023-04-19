/// @description Insert description here
// You can write your code in this editor

if (global.is_host)
{
	send_data({cmd: "destroy_tile", x: x, y: y});
}

global.tiles_list.remove(id);

if (instance_exists(owner) && ds_exists(owner.chunk_grid, ds_type_grid) && grid_pos != noone)
{
	owner.chunk_grid[# grid_pos.x, grid_pos.y] = 0;
}