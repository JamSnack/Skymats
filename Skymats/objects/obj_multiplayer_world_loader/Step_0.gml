/// @description Insert description here
// You can write your code in this editor
if (target_socket == -1)
	exit;
	
if (!global.is_host)
{
	instance_destroy();
	exit;
}

//Activate a chunk
instance_activate_region(x, y, x + boundary_width, y + boundary_height, true);

//Figure out what's in it
if (collision_list_size == 0)
	collision_list_size = collision_rectangle_list(x, y, x + boundary_width, y + boundary_height, TILE, false, true, collision_list, false);
else
{
	//- send data
	//show_debug_message("Sending data... " + string(target_socket));
	var _ti = collision_list[| --collision_list_size];
	
	if (instance_exists(_ti))
		send_data({cmd: "create_tile", x: _ti.x, y: _ti.y, item_id: _ti.item_id}, target_socket);
}

//Time to reset the object and contineu:
if (collision_list_size == 0)
{
	//Reset list
	ds_list_clear(collision_list);

	//Deactivate tiles but run camera's reactivation event
	instance_deactivate_object(TILE);
	with (camera)
		event_user(0);

	//Push boundary
	x += boundary_width;

	if (x >= room_width)
	{
		x = 0;
		
		y += boundary_height;
	
		if (y >= room_height)
			instance_destroy(); //mission complete!
			
		show_debug_message("Next row!");
	}
}