/// @description Insert description here
// You can write your code in this editor
randomize();
show_debug_overlay(false);

//test_list = ds_list_create();
//ds_list_add(test_list, id);
//save_dungeon("DrakesDungeon", test_list);

//load_dungeon("DrakesDungeon");

//networking
enemy_spawn_delay = 0;

//Game information
character_file = -1;
username = "Player";
exped_name = "expedition";

draw_set_font(fnt_default);
scribble_font_bake_outline_4dir("fnt_default", "default_outlined", c_black, false);
room_goto(rm_menu);

network_timeout = 500;