/// @description Draw Window and its contents

//Draw background
if (sprite_exists(sprite_background))
{
	draw_sprite_stretched(sprite_background, 0, pos_x, pos_y, width, height);
}

//Draw widgets
if (!surface_exists(window_surface) && width > 0 && height > 7)
{
	window_surface = surface_create(width, height - 6);

	surface_set_target(window_surface);

	if (widgets.widgets_amount > 0)
	{
		var last_y = scroll_offset + draw_topbar*(_topbar_height + widget_padding);
		for (var _w = 0; _w < widgets.widgets_amount; _w++)
		{
			var current_widget = widgets.widgets[| _w];
		
			if (instance_exists(current_widget))
			{
				draw_rectangle_color(3, last_y, width - 4, last_y + current_widget.length, c_black, c_black, c_black, c_black, false);				
				
				//var temp_surface = surface_create(width-4, current_widget.length);
				
				//surface_set_target(temp_surface);
				
				with current_widget { draw_widget(other.width/2, other.widget_padding + last_y); };
				
				//surface_reset_target();
				//surface_set_target(window_surface);
				
				//draw_surface(temp_surface, 3, last_y);
				
				//surface_reset_target();
				
				last_y += current_widget.length + widget_padding;
			}
		}
	}

	surface_reset_target();
}

if (surface_exists(window_surface))
	draw_surface(window_surface, pos_x, pos_y + 3);

//Draw topbar
if (draw_topbar)
{
	draw_sprite_stretched(sprite_background, 0, pos_x, pos_y, width, _topbar_height);
}

//Draw scrollbar
if (scrollable && widgets.widget_length > height)
{
	//background
	draw_rectangle_color(pos_x + width + 4, pos_y, pos_x + width + 4 + 4, pos_y + height, c_black, c_black, c_black, c_black, false);
	draw_rectangle_color(pos_x + width + 4, pos_y + scroll_offset*(scroll_offset/max_scroll_offset), pos_x + width + 4 + 4, pos_y + height-max_scroll_offset + scroll_offset*(scroll_offset/max_scroll_offset), c_white, c_white, c_white, c_white, false);
}
