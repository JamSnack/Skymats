/// @description Insert description here
// You can write your code in this editor

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _holding_left_click = mouse_check_button(mb_left);
var _pressed_left_click = mouse_check_button_pressed(mb_left);
var _released_left_click = mouse_check_button_released(mb_left);
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
			scroll_offset_target += scroll_speed;
			//_free_surface = true;
		}
		else if (mouse_wheel_down())
		{
			scroll_offset_target -= scroll_speed;
			//_free_surface = true;
		}
		
		//Clamp
		max_scroll_offset = max(0, scroll_length - height);
		scroll_offset_target = clamp(scroll_offset_target, -max_scroll_offset, 0);
	}
	
	//Interact with Auto-Burn menu
	if (_released_left_click)
	{
		var _y1 = 16 + scroll_offset + 128;
		var _y2 = _y1 + 256;
	
		for (var _i = 1; _i < ITEM_ID.last; _i++)
		{
			if (_i >= ITEM_ID.enemy_parts)
			{
				if (_i == ITEM_ID.enemy_parts)
					_y2 += 32+16;
			}
		
			var _current_y = _y2 - 4 + _i*32;
		
			if (global.stored_resources_unlocked[_i] && point_in_rectangle(_mx, _my, pos_x + 2, pos_y + _current_y + 2, pos_x + width-2, pos_y + _current_y + 30))
			{
				global.stored_resources_auto_burn[_i] = !global.stored_resources_auto_burn[_i];
			
				if (global.stored_resources_auto_burn[_i])
					global.stored_resource_to_burn = _i;
				else if (global.stored_resource_to_burn == _i)
					global.stored_resource_to_burn = 0;
				
				_free_surface = true;
			
				//Play sound effect
			
				break;
			}
		}
	}
}
else
{
	if (window_get_cursor() != cr_default)
		window_set_cursor(cr_default);
		
	if (click_off_to_close && _released_left_click)
		instance_destroy();
}
	
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
	//_free_surface = true;
}
	
if (height != target_height)
{
	height = lerp(height, target_height, 0.43);
	//_free_surface = true;
}

if (scroll_offset != scroll_offset_target)
{
	scroll_offset = lerp(scroll_offset, scroll_offset_target, 0.33);
	//_free_surface = true;
}

//Window alpha
if (window_alpha != 1)
{
	window_alpha = lerp(window_alpha, 1, 0.33);
	_free_surface = true;
}

//free surface
if (_free_surface)
{
	surface_free(content_surface);
	//window_surface = -1;
}