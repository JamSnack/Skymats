 /// @description Insert description here
// You can write your code in this editor
var left_released = mouse_check_button_released(mb_left);

if (point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom))
{
	outlined = true;
	
	if (!left_pressed && mouse_check_button_pressed(mb_left))
		left_pressed = true;
	else if (left_pressed && left_released)
	{
		if (!instance_exists(obj_ui_fuel_menu))
		{
			instance_create_layer(455, -600, "Instances", obj_ui_fuel_menu);
			//_w.widgets.add(instance_create_layer(0, 0, "Instances", obj_ui_current_fuel));
			//_w.widgets.add(instance_create_layer(0, 0, "Instances", obj_ui_stored_resource_grid));
		}
		
		left_pressed = false;
	}
}
else 
{
	left_pressed = false;
	outlined = false;
}