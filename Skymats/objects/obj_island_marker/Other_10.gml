/// @description Send INIT packet

if (global.is_host)
{
	send_data({cmd: "init_island_marker", x: x, y: y, chunk_string: ds_grid_write(chunk_grid_type), connected_id: connected_id});
}