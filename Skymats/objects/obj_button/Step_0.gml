/// @description Insert description here
// You can write your code in this editor
image_index = 0;

if (visible && point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), bbox_left, bbox_top, bbox_right, bbox_bottom))
{
	image_index = 1;
	
	if (mouse_check_button(mb_left))
		image_index = 2;

	if (mouse_check_button_released(mb_left))
		event_user(0);
}