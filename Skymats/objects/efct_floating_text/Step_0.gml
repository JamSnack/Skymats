/// @description Insert description here
// You can write your code in this editor

y -= 0.5;
lifetime -= 0.1;
image_alpha = lifetime;

//gui_coords = world_to_gui_coords(x, y);

if (lifetime <= 0)
	instance_destroy();