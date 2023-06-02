/// @description Insert description here
// You can write your code in this editor
randomize();
show_debug_overlay(true);

test_list = ds_list_create();
ds_list_add(test_list, id);
save_dungeon("DrakesDungeon", test_list);

//networking
global.socket_list = ds_list_create();
global.is_host = false;
global.client_id = -1;
global.next_id = 1;
global.world_seed = -1;
global.host_socket = noone; //Clients use this to store the host's socket id.
global.multiplayer = false; //Whether or not we are now allowed to transmit packets.
global.lag = 0;
global.current_tick = 0;

global.game_state = "PLAY";

enemy_spawn_delay = 0;

//Game information
character_file = -1;
username = "Player";
exped_name = "expedition";

draw_set_font(fnt_default);
scribble_font_bake_outline_4dir("fnt_default", "default_outlined", c_black, false);
room_goto(rm_menu);

network_timeout = 500;