if (global.is_host)
{
	//Simple player-tracking Ai
	var _p = target;
	
	if (_p != -1 && instance_exists(target))
	{
		motion_add_custom(point_direction(x, y, _p.x, _p.y), 0.5);
		
		if (target.hp <= 0)
			instance_destroy();
	}
	else instance_destroy();
		
	x += hspd;
	y += vspd;
	
	image_angle += (hspd + vspd);
	
	//Check for death
	if (hp <= 0)
		instance_destroy();
	
	//Speed clamp
	clamp_speed(-max_hspeed, max_hspeed, -max_vspeed, max_vspeed);
}

event_inherited();