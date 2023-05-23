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
	if (_my < _h/2)
	{
		var _x = _w/2 - w_size/2 + character_x_offset;
		var _y = _h/6 - 60;
		
		//Characters
		for (var i=-1; i<characters; i++)
		{
			if ( point_in_rectangle(_mx, _my, _x, _y, _x + w_size, _y + h_size))
				character_selected = i;
	
			_x += h_size;
		}
	}
	else
	{
		var _x = _w/2 - w_size_exped/2 + expedition_x_offset;
		var _y = _h - _h/6 - 200;
		
		//Expeditions
		for (var i=-1; i<expeditions; i++)
		{
			if ( point_in_rectangle(_mx, _my, _x, _y, _x + w_size_exped, _y + h_size_exped))
				expedition_selected = i;
	
			_x += w_size_exped + 32;
		}
	}
	
	//Begin game
	if (point_in_rectangle(_mx, _my, _w/2 - 80, _h/2 - 40, _w/2 + 80, _h/2 + 30))
	{
		event_user(0);
	}
}

//Window alpha
if (window_alpha != 1)
{
	window_alpha = lerp(window_alpha, 1, 0.33);
}

//Lerping
character_x_offset = lerp(character_x_offset, -192*(character_selected+1), 0.25);
expedition_x_offset = lerp(expedition_x_offset, -(w_size_exped + 32)*(expedition_selected+1), 0.25);