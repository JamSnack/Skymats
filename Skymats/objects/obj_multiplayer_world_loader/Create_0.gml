/// @description Insert description here
// You can write your code in this editor
boundary_width  = room_width;//WORLD_BOUND_RIGHT;
boundary_height = room_height;//WORLD_BOUND_TOP-WORLD_BOUND_BOTTOM;

collision_list = ds_list_create();
collision_list_size = 0;

packet_string = "";
packet_batch = buffer_create(128, buffer_grow, 1);

//instance_activate_region(x, y, x + boundary_width, y + boundary_height, true);
delay = 4;