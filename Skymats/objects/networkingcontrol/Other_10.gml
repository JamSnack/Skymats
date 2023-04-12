/// @description Host Server
global.is_host = true;
global.client_id = 0;
global.world_seed = random_get_seed();

var port = 6510;
server = network_create_server(network_socket_tcp, port, 32);

while (server < 0 && port < 65535)
{
    port++
    server = network_create_server(network_socket_tcp, port, 32);
}

obj_chat_box.add("Server created successfully on port: " + string(port));

show_debug_message("Created server");

global.multiplayer = true;