/// @description Insert description here
// You can write your code in this editor

follow_this = obj_player;
local_camera = view_get_camera(view_current);

zoom = 2;
lerped_zoom = zoom;

last_chunk_x = 0;
last_chunk_y = 0;
boundary_size = CHUNK_HEIGHT;

sync_delay = 60*5;

