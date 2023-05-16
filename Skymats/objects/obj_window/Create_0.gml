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
scroll_offset = 0;
max_scroll_offset = 0;

//Constants
_topbar_height = 30;

//Widgets
widgets = {
	widgets : ds_list_create(),
	widgets_amount : 0,
	widget_length : 0,
	parent_window : id,
	add : function(new_widget)
	{
		ds_list_add(widgets, new_widget);
		show_debug_message("test");
		widgets_amount++;
		
		widget_length += (new_widget.length + 10);
		surface_free(parent_window.window_surface);
	},
	remove : function(target_widget)
	{
		var _t = ds_list_find_index(widgets, target_widget);
		
		if (_t != -1)
		{
			ds_list_delete(widgets, _t);
			widgets_amount--;
			widget_length -= (_t.length + 10);
			surface_free(parent_window.window_surface);
			
			with (_t) instance_destroy();
		}
	},
	removeAll : function()
	{
		for (var _k = 0; _k < widgets_amount; _k++)
		{
			var _t = ds_list_find_value(widgets, _k);
		
			if (_t != -1)
			{
				widget_length -= (_t.length + 10);
				with (_t) instance_destroy();
			}
		}
		
		ds_list_clear(widgets);
		widgets_amount = 0;
		surface_free(parent_window.window_surface);
	}
	
	
}

//Window surface
window_surface = noone;

//Other Window
window_alpha = 0;

/*
TODO:
- Collapse Arrow bool
- Widgets
- - Buttons
*/