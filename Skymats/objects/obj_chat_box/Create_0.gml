/// @description Insert description here
// You can write your code in this editor
width = 400;
height = 200;

mouse_x_before_pressed = 0;
mouse_y_before_pressed = 0;
dragging = false;

chat_surface = noone;
chat_string = "";
chat_message = "";

char_append_delay = 0;

chat_alpha = 17;
chat_alpha_set = 17;


function add(text)
{
	chat_string += text + "[c_white]\n";
	chat_alpha = chat_alpha_set;
}

global.chatting = false;