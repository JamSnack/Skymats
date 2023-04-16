/// @description Insert description here
// You can write your code in this editor

//var _w = display_get_gui_width();
//var _h = display_get_gui_height();

draw_text(1100, 10, 
	"Socket_list size: " + string(ds_list_size(global.socket_list)) + "\n" +
	"Client ID: " + string(global.client_id) + "\n" +
	"Chunk Request Objects: " + string(instance_number(obj_client_request_chunk)) + "\n" +
	"Tiles: " + string(instance_number(TILE)) + "\n" +
	"Lag: " + string(global.lag)


);
/*
if (instance_exists(obj_island_generator) || instance_exists(obj_ore_generator))
{
	draw_set_alpha(0.5);
	draw_rectangle_color(0, 0, _w, _h, c_black, c_black, c_black, c_black, false);
	draw_set_alpha(1);
	
	draw_set_color(c_white);
	
	draw_set_halign(fa_center);
	draw_text(_w/2, _h/2, "Loading World...");
	
	
	if (instance_exists(obj_island_generator))
	{
		draw_text(_w/2, _h/2+40, "Creating Sky Islands..." + string(100*((island_generators - instance_number(obj_island_generator))/island_generators)) + "%");
	}
	else if (instance_exists(obj_ore_generator))
	{
		draw_text(_w/2, _h/2+40, "Generating Ore Veins...");
	}
	
	//reset
	draw_set_halign(fa_left);
}