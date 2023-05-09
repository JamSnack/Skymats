/// @description Insert description here
// You can write your code in this editor

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _holding_left_click = mouse_check_button(mb_left);
var _pressed_left_click = mouse_check_button_pressed(mb_left);
var _free_surface = false;

//Window interaction
if (point_in_rectangle(_mx, _my, pos_x, pos_y, pos_x + width, pos_y + height))
{	
	//Dragging	
	if (draggable)
	{
		if (_pressed_left_click && (!draw_topbar || (draw_topbar && point_in_rectangle(_mx, _my, pos_x, pos_y, pos_x + width, pos_y + _topbar_height))))
		{
			mouse_drag_offset_x = _mx - pos_x;
			mouse_drag_offset_y = _my - pos_y;
			dragging = true;
		}
	}
	
	
	//Resizing
	if (resizeable && !resizing)
	{
		var _border = 3;
		var _left = point_in_rectangle(_mx, _my, pos_x, pos_y, pos_x + _border, pos_y + height);
		var _top =  point_in_rectangle(_mx, _my, pos_x, pos_y, pos_x + width, pos_y + _border);
		var _bottom =  point_in_rectangle(_mx, _my, pos_x, pos_y + height - _border, pos_x + width, pos_y + height);
		var _right =  point_in_rectangle(_mx, _my, pos_x + width - _border, pos_y, pos_x + width, pos_y + height);
		
		if ((_left && _top) || (_right && _bottom))
			window_set_cursor(cr_size_nwse);
		else if ((_right && _top) || (_left && _bottom))
			window_set_cursor(cr_size_nesw);
		else if (_left || _right)
			window_set_cursor(cr_size_we);
		else if (_top || _bottom)
			window_set_cursor(cr_size_ns);
		else window_set_cursor(cr_default);
		
		if (_pressed_left_click && (_left || _top || _right || _bottom))
		{
			resizing = true;
			resize_left = _left;
			resize_right = _right;
			resize_top = _top;
			resize_bottom = _bottom;
			mouse_resize_offset_x = _mx;
			mouse_resize_offset_y = _my;
		}
	}
	
	//Scrolling
	if (scrollable && !dragging && !resizing)
	{
		if (mouse_wheel_up())
		{
			scroll_offset -= scroll_speed;
			_free_surface = true;
		}
		else if (mouse_wheel_down())
		{
			scroll_offset += scroll_speed;
			_free_surface = true;
		}
		
		//Clamp
		max_scroll_offset = max(0, widgets.widget_length - height);
		scroll_offset = clamp(scroll_offset, -max_scroll_offset, 0);
	}
}
else if (window_get_cursor() != cr_default)
	window_set_cursor(cr_default);
	
//Continuous dragging
if (dragging && !resizing && _holding_left_click)
{
	target_x = _mx - mouse_drag_offset_x;
	target_y = _my - mouse_drag_offset_y;
} else dragging = false;

//Continuous resizing
if (resizing && _holding_left_click)
{
	if (resize_right)
		target_width = _mx - pos_x;
	else if (resize_left)
	{
		target_width = width + (pos_x - _mx);
		target_x = _mx;
	}
	
	if (resize_bottom)
		target_height = _my - pos_y;
	else if (resize_top)
	{
		target_height = height + (pos_y - _my);
		target_y = _my;
	}
}
else 
{
	resizing = false;
	resize_left = false;
	resize_right = false;
	resize_top = false;
	resize_bottom = false;
}

//Lerping
if (pos_x != target_x)
	pos_x = lerp(pos_x, target_x, 0.43);
	
if (pos_y != target_y)
	pos_y = lerp(pos_y, target_y, 0.43);
	
if (width != target_width)
{
	width = lerp(width, target_width, 0.43);
	_free_surface = true;
}
	
if (height != target_height)
{
	height = lerp(height, target_height, 0.43);
	_free_surface = true;
}

//free surface
if (_free_surface)
	surface_free(window_surface);