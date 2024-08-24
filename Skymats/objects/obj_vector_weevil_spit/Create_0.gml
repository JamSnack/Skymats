/// @description Insert description here
// You can write your code in this editor
var _p = instance_nearest(x, y, PLAYER);

if (_p != noone)
{
	var _dir = point_direction(x, y, _p.x, _p.y - 8 - random_factor*4);
	motion_add_custom(_dir, 8);
}

// Inherit the parent event
event_inherited();

