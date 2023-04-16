/// @description Insert description here
// You can write your code in this editor
if (delay > 0)
{
	delay--;
	exit;
}

if (!global.is_host || target_socket == -1)
{
	instance_destroy();
	exit;
}

//Create a buffer to use later
if (packet_string = "")
{
	packet_string = "{\"cmd\": \"create_chunk\", \"x\": " + string(x) + ", \"y\":" + string(y) + ", \"tick\": " + string(global.current_tick) + ", \"tiles\": [";
	
	//Activate a chunk
	
}
//buffer_write(packet_batch, buffer_text, json_stringify({cmd: "create_chunk"}));

//Figure out what's in it
if (collision_list_size == 0)
{
	collision_list_size = collision_rectangle_list(x - 500, y - 500, x + boundary_width + 500, y + boundary_height + 500, TILE, false, true, collision_list, false);
}
else
{
	//- send data
	//show_debug_message("Sending data... " + string(collision_list_size));
	var _c = collision_list_size;
	
	repeat(min(_c, 10))
	{
		var _ti = collision_list[| --collision_list_size];
	
		if (instance_exists(_ti))
		{
			//ds_list_add(packet_list, {_ti:item_id, _ti:x, _ti:y});
			packet_string += "{\"item_id\": " + string(_ti.item_id) + ", \"x\": " + string(_ti.x) + ", \"y\": " + string(_ti.y) +"}, ";
			//var _data = json_stringify({cmd: "create_tile", item_id: _ti.item_id, x: _ti.x, y: _ti.y});
			//buffer_write(packet_batch, buffer_text, _data);
			//send_data({cmd: "create_tile", x: _ti.x, y: _ti.y, item_id: _ti.item_id}, target_socket);
		}
	}
}

//Time to reset the object and contineu:
if (collision_list_size == 0)
{
	//Send the batch 
	//show_debug_message("Sending chunk...");
	packet_string += "]}";
	//show_debug_message(packet_string);
	//show_debug_message(json_parse(packet_string));
	
	packet_batch = buffer_create(128, buffer_grow, 1);
	buffer_write(packet_batch, buffer_text, packet_string);
	network_send_packet(target_socket, packet_batch, buffer_tell(packet_batch));
	
	//Reset list and buffer
	ds_list_clear(collision_list);
	packet_string = "";
	buffer_delete(packet_batch);

	//Deactivate tiles but run camera's reactivation event
	//instance_deactivate_object(TILE);
	//with (camera)
		//event_user(0);
		
	//Kill early if single_chunk
	if (single_chunk)
	{
		//show_debug_message("Chunk sent! destroying object");
		send_data({cmd: "chunk_sent", x: x, y: y}, target_socket);
		instance_destroy();	
	}

	//Push boundary
	x += boundary_width;

	if (x >= room_width)
	{
		x = 0;
		
		y -= boundary_height;
	
		if (y <= 0)
		{
			send_data({cmd: "world_loaded"}, target_socket);
			instance_destroy(); //mission complete!
		}
			
		//show_debug_message("Next row!");
	}
}