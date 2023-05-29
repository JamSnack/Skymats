/// @description
lifetime -= 0.01;

if (lifetime <= 0)
	instance_destroy();

image_angle += hspeed*2;