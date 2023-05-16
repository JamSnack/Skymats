/// @description Insert description here
// You can write your code in this editor
width = 400;
height = 200;

x = 1366;
y = 768;

mouse_x_before_pressed = 0;
mouse_y_before_pressed = 0;
dragging = false;

chat_surface = noone;
chat_string = "";
chat_message = "";

char_append_delay = 0;

chat_alpha = 17;
chat_alpha_set = 17;
chat_message_offset = 0;
chat_message_offset_draw = 0;


function add(text)
{
	chat_string += "\n" + text + "[c_white]";
	chat_message_offset += 16;
	
	if (string_height(chat_string) > 300)
	{
		var _c = string_pos("\n", chat_string);
		chat_string = string_delete(chat_string, 1, _c);
	}
		
	chat_alpha = chat_alpha_set;
}

global.chatting = false;