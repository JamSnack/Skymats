/// @description Insert description here
// You can write your code in this editor
event_inherited();

connect_to_server(get_string("Enter IP", "26.198.169.147"), real(string_digits(get_string("Enter Port", "6510"))));
networkingControl.loading_world = true;
room_goto(rm_small);