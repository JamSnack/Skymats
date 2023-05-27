/// @description Insert description here
// You can write your code in this editor

//Init lerping
target_x = pos_x;
target_y = pos_y;
target_width = width;
target_height = height;

//Init dragging
mouse_drag_offset_x = 0;
mouse_drag_offset_y = 0;
dragging = false;

//Init resize
resize_left = false;
resize_right = false;
resize_top = false;
resize_bottom = false;
mouse_resize_offset_x = 0;
mouse_resize_offset_y = 0;
resizing = false;

//Init scrolling
scroll_offset_target = 0;
scroll_offset = 0;
max_scroll_offset = 0;
scroll_length = 40; //How much to scroll

//Constants
_topbar_height = 30;

//Window surface
window_surface = noone;
content_surface = noone;

//Other Window
window_alpha = 0;


//Local
typing_name = false;
username = networkingControl.username;