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
	
camera_set_view_pos(local_camera, clamp(x - 1366/(2*lerped_zoom), 0, room_width-768), clamp(y - 768/(2*lerped_zoom), WORLD_BOUND_TOP, WORLD_BOUND_BOTTOM));

//Tile culling
/*
if (keyboard_check_released(vk_rshift) && global.is_host == false)
{
	with (TILE)
		instance_destroy();
		
	//instance_create_layer(0, 0, "Instances", obj_client_request_chunk);
	//sync_chunks();
}
*/

//Void
layer_y("Void", global.platform_height);

//Paralaxing
var _x = camera_get_view_x(view_camera[0]);
var _y = camera_get_view_y(view_camera[0]);
layer_y("Background_Mountains", _y*0.6);
layer_y("Background_Trees_1", _y*0.1);
layer_y("Background_Trees_2", _y*0.2);

layer_x("Background_Trees_1", _x*0.1);
layer_x("Background_Trees_2", _x*0.2);
layer_x("Background_Mountains", _x*0.6);

part_system_position(global.background_particles, _x*0.9, (_y-global.platform_height)*0.9);
part_system_position(global.foreground_particles, _x*(-0.1), (_y-global.platform_height)*(-0.1));