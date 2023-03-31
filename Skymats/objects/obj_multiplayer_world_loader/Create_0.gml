/// @description Insert description here
// You can write your code in this editor
boundary_width  = CHUNK_WIDTH;
boundary_height = CHUNK_HEIGHT;

collision_list = ds_list_create();
collision_list_size = 0;

packet_string = "";
packet_batch = buffer_create(128, buffer_grow, 1);