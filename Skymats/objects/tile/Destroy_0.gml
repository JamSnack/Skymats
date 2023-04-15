/// @description Insert description here
// You can write your code in this editor

if (global.is_host)
{
	send_data({cmd: "destroy_tile", x: x, y: y});
}

global.tiles_list.remove(list_position);