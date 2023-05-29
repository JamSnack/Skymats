/// @description
lifetime -= 0.1;

if (lifetime <= 0)
	instance_destroy();

image_angle += hspeed;