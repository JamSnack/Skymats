/// @description Insert description here
// You can write your code in this editor

if (instance_exists(PLAYER) && instance_exists(obj_platform))
{
	var _p = collision_rectangle(bbox_left, bbox_top-8, bbox_right, bbox_top, PLAYER, false, true);
	
	if (_p != noone && _p.hspd == 0 && _p.vspd == 0)
	{
		if (!pressed)
			obj_platform.powered = !obj_platform.powered;
			
		pressed = true;
	}
	else pressed = false;
}
else pressed = false;