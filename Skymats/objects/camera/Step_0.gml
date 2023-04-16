/// @description

//move the object
if (instance_exists(follow_this))
{
	x = lerp(x, follow_this.x, 0.25);
	y = lerp(y, follow_this.y, 0.25);
}

//update camera
if (lerped_zoom != zoom)
{
	lerped_zoom = lerp(lerped_zoom, zoom, 0.1);
	camera_set_view_size(local_camera,  view_wport[0]/lerped_zoom, view_hport[0]/lerped_zoom);
}
	
camera_set_view_pos(local_camera, x - 1366/(2*lerped_zoom), y - 768/(2*lerped_zoom));

/*
	
if (sync_delay < 0 && !global.is_host)
{
	sync_delay = 60*120;
}else sync_delay--;
*/
//Tile culling
if (keyboard_check_released(vk_rshift) && global.is_host == false)
{
	with (TILE)
		instance_destroy();
		
	//instance_create_layer(0, 0, "Instances", obj_client_request_chunk);
	sync_chunks();
}
/*
if (!instance_exists(obj_multiplayer_world_loader) && point_distance(x, y, last_chunk_x, last_chunk_y) >= boundary_size)
{
	//event_user(0);
	
	//if (!global.is_host)
		//sync_chunks();
		
	//last_chunk_x = x;
	//last_chunk_y = y;
}