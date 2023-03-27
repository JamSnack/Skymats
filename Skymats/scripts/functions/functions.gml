// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

#macro GRAVITY 0.1
#macro WORLD_BOUND_LEFT 0
#macro WORLD_BOUND_RIGHT room_width
#macro WORLD_BOUND_TOP 0
#macro WORLD_BOUND_BOTTOM room_height

function approach(a, b, amt)
{
	if (a < b)
	    return min(a + amt, b); 
	else
	    return max(a - amt, b);	
}

function calculate_collisions()
{
	//Horizontal collision
	if (collision_rectangle(bbox_left + hspd, bbox_top, bbox_right + hspd, bbox_bottom, OBSTA, false, true) != noone)
	{
		var _h = (hspd > 0) ? min(sign(hspd), hspd) : max(sign(hspd), hspd);
	
		while (collision_rectangle(bbox_left + _h, bbox_top, bbox_right + _h, bbox_bottom, OBSTA, false, true) == noone)
		{
			x += _h;
		}
	
		hspd = 0;
	}

	x += hspd;

	//Vertcial Collision
	if (collision_rectangle(bbox_left, bbox_top + vspd, bbox_right, bbox_bottom + vspd, OBSTA, false, true) != noone)
	{
		var _v = (vspd > 0) ? min(sign(vspd), vspd) : max(sign(vspd), vspd);
	
		while (collision_rectangle(bbox_left, bbox_top + _v, bbox_right, bbox_bottom + _v, OBSTA, false, true) == noone)
		{
			y += _v;
		}
	
		vspd = 0;
	}

	y += vspd;	
}

function clamp_speed(min_hspd, max_hspd, min_vspd, max_vspd)
{
	hspd = clamp(hspd, min_hspd, max_hspd);
	vspd = clamp(vspd, min_vspd, max_vspd);
}

function get_item_name(item_id)
{
	
}

function motion_add_custom(_direction, _speed)
{
	//init vector for use in proceeding speed calculations
	direction = _direction;
	speed = _speed;
	
	//apply speed at some direction to homemode variables
	hspd += hspeed;
	vspd += vspeed;
	
	//reset
	speed = 0;
}

enum ITEM_ID
{
	none,
	grass,
	last
}