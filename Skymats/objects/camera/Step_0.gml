/// @description

//move the object
if (instance_exists(follow_this))
{
	x = lerp(x, follow_this.x, 0.25);
	y = lerp(y, follow_this.y, 0.25);
}

//update camera
if (lerped_zoom != zoom)
	lerped_zoom = lerp(lerped_zoom, zoom, 0.1);
	
camera_set_view_size(local_camera,  view_wport[0]/lerped_zoom, view_hport[0]/lerped_zoom);
camera_set_view_pos(local_camera, x - window_get_width()/(2*lerped_zoom), y - window_get_height()/(2*lerped_zoom));


//Tile culling
if ((!instance_exists(obj_multiplayer_world_loader) && global.is_host) && point_distance(x, y, last_chunk_x, last_chunk_y) >= boundary_size)
{
	event_user(0);
}