/// @description Insert description here
// You can write your code in this editor
x = clamp(x, 0, 1366-width);
y = clamp(y, 0, 768-height);

if (room == rm_menu)
	visible = false;
else visible = true;

if (!visible)
	exit;

width = clamp(width, 2, 1366);
height = clamp(height, 2, 768);

if (point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x + width, y + height))
{
	if (mouse_check_button_pressed(mb_left))
	{
		mouse_x_before_pressed = device_mouse_x_to_gui(0) - x;
		mouse_y_before_pressed = device_mouse_y_to_gui(0) - y;
		dragging = true;
	}
}


if (dragging)
{
	if (mouse_check_button(mb_left))
	{
		x = device_mouse_x_to_gui(0) - mouse_x_before_pressed;
		y = device_mouse_y_to_gui(0) - mouse_y_before_pressed;
	}
	else dragging = false;
}

//Chatting
if (keyboard_check_released(vk_enter))
{
	if (global.chatting)
	{
		send_data({cmd: "chat", text: chat_message});
		add(chat_message);
		chat_message = "";
	}
	
	global.chatting = !global.chatting;
	keyboard_string = "";
	
	if (global.chatting)
		chat_alpha = chat_alpha_set;
}

if (global.chatting)
{
	if (keyboard_key != 0)
	{
		chat_message = keyboard_string;
	}
}

if (char_append_delay > 0)
	char_append_delay--;
	
if (chat_alpha > 0.1)
	chat_alpha -= 0.02;