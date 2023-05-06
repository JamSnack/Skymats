/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_market))
{
	x = lerp(x, obj_market.x, time);
	y = lerp(y, obj_market.y, time);

	if (point_distance(x, y, obj_market.x, obj_market.y) < 32)
		instance_destroy();
} else instance_destroy();


time += time/10 + 0.001;