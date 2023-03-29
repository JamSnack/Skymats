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
if (point_distance(x, y, last_chunk_x, last_chunk_y) >= boundary_size)
{
	last_chunk_x = x;
	last_chunk_y = y;
		
	//Deactivate all tiles
	instance_deactivate_object(TILE);
		
	//Reactivate tiles around the player
	var _boundary = boundary_size*2;
	instance_activate_region(last_chunk_x-_boundary, last_chunk_y-_boundary, _boundary*2, _boundary*2, true);
		
		
	//This should happen because we just deactivated all tiles and we need to make sure enemies don't clip into things
	/*if (global.is_host == true)
	{
		with (ENEMY)
		{
			instance_activate_region(x-_boundary/4, y-_boundary/4, _boundary/2, _boundary/2, true);
		}
	}*/
}