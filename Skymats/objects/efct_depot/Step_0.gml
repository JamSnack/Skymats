/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_platform))
{
	x = lerp(x, obj_platform.x, time);
	y = lerp(y, obj_platform.y, time);

	if (point_distance(x, y, obj_platform.x, obj_platform.y) < 32)
		instance_destroy();
} else instance_destroy();


time += time/10 + 0.001;