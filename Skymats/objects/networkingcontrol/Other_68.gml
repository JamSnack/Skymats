/// @description Handle networking
var t = async_load[? "type"];
switch(t)
{
	case network_type_connect:
	{
		var _sock = async_load[? "socket"];
		ds_list_add(global.socket_list, _sock);
		
		//Start sending world data
		instance_create_layer(0, 0, "Instances", obj_multiplayer_world_loader, {target_socket: _sock});
		
		show_debug_message("Played connected");
	}
	break;
	
	case network_type_disconnect:
	{
		ds_list_delete(global.socket_list, ds_list_find_index(global.socket_list, async_load[? "socket"]));
		show_debug_message("Played disconnected");
	}
	break;
	
	case network_type_data:
	{
		var b_data = async_load[? "buffer"];
		var data = buffer_read(b_data, buffer_text);
		
		//unpickle the data
		/*
		var _l = string_length(data)
		var temp_data = "";
		
		for (var i = 1; i <= _l; i++)
		{
			var _c = string_char_at(data, i);
			
			temp_data += _c;
			
			if (_c == "}")
			{
				handle_data(temp_data);
				temp_data = "";
			}
		}*/
		handle_data(data);
		
		//buffer cleanup
		buffer_delete(b_data);
	}
	break;
}
