/// @description Insert description here
// You can write your code in this editor
time++;

if (!global.is_host)
{
	//Don't request chunks we are suddenly far away from
	if (instance_exists(obj_player) && distance_to_object(obj_player) > CHUNK_WIDTH*2)
		instance_destroy();

	//Request chunk
	send_data({cmd: "request_chunk", x: x, y: y});
	
	instance_destroy();
}