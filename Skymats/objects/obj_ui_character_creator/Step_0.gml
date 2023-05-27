/// @description Insert description here
// You can write your code in this editor

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
//var _holding_left_click = mouse_check_button(mb_left);
//var _pressed_left_click = mouse_check_button_pressed(mb_left);
var _released_left_click = mouse_check_button_released(mb_left);

var _w = display_get_gui_width();
var _h = display_get_gui_height();


// Button interaction
if (_released_left_click)
{
	var h_size = 80;
	var w_size = 600;
	var _x = _w/2 - w_size/2;
	var _y = _h/2 - h_size/2;
	
	if (!typing_name && point_in_rectangle(_mx, _my, _x, _y, _x + w_size, _y + h_size))
	{
		typing_name = true;
		keyboard_string = "";
	}
	
	//Play button
	var h_size = 90;
	var w_size = 400;
	if (point_in_rectangle(_mx, _my, _x, _y + 320, _x + w_size, _y + h_size + 320))
	{
		event_user(0);
	}
}

//Window alpha
if (window_alpha != 1)
{
	window_alpha = lerp(window_alpha, 1, 0.33);
}

//Handle keyboard
if (keyboard_check_released(vk_enter))
{
	if (typing_name)
	{
		keyboard_string = "";
		typing_name = false;
	}
}

if (typing_name)
{
	if (keyboard_key != 0 && (string_length(username) < 30 || keyboard_key == vk_backspace ))
	{
		username = keyboard_string;
	}
}