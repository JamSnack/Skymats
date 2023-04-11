/// @description Insert description here
// You can write your code in this editor

follow_this = obj_player;
local_camera = view_get_camera(view_current);

zoom = 2;
lerped_zoom = 0;

camera_set_view_size(local_camera,  view_wport[0]/lerped_zoom, view_hport[0]/lerped_zoom);

last_chunk_x = 0;
last_chunk_y = 0;
boundary_size = 368;

sync_delay = 60*120;
