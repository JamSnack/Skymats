/// @description Insert description here
// You can write your code in this editor

draw_set_alpha(chat_alpha);

//main body
draw_sprite_stretched(spr_ui_black_background, 0, x, y, width, height);

//Chat contents
if (!surface_exists(chat_surface))
	chat_surface = surface_create(width, height);
	
surface_set_target(chat_surface);
draw_clear_alpha(c_white, 0);

draw_text_scribble_ext(4, 4 - chat_message_offset_draw, chat_string, width - 4);

surface_reset_target();

//Draw chat
draw_surface(chat_surface, x, y);

//reset
draw_set_alpha(1);

//Input field
draw_sprite_stretched(spr_ui_black_background, 0, x, y + height + 8, width, 32);

draw_text_scribble(x + 4, y + height + 13, global.chatting ? chat_message : "Press 'Enter' to chat.");