/// @description Insert description here
// You can write your code in this editor

follow_this = obj_player;

if (instance_exists(follow_this))
{
	x = follow_this.x;
	y = follow_this.y;
}

local_camera = view_get_camera(view_current);

zoom = 2;
lerped_zoom = zoom;

camera_set_view_size(local_camera,  view_wport[0]/lerped_zoom, view_hport[0]/lerped_zoom);

last_chunk_x = 0;
last_chunk_y = 0;
boundary_size = 368;

//layer_depth("Void", -99);
//mountains = layer_sprite_get_id("Background_Elements1", bkg_mountains);
//trees = layer_sprite_get_id("Background_Elements1", bkg_trees);
