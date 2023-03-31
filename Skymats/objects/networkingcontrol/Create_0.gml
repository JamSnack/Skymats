/// @description Insert description here
// You can write your code in this editor

//networking
global.socket_list = ds_list_create();
global.is_host = false;
global.client_id = -1;
global.next_id = 1;
global.host_socket = noone; //Clients use this to store the host's socket id.
global.multiplayer = false; //Whether or not we are now allowed to transmit packets.

global.game_state = "PLAY";

enemy_spawn_delay = 0;
loading_world = false;
island_generators = 32;

load_timer = 30;

chat_animation = 1;