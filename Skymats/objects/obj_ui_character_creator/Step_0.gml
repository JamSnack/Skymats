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

}

//Window alpha
if (window_alpha != 1)
{
	window_alpha = lerp(window_alpha, 1, 0.33);
}