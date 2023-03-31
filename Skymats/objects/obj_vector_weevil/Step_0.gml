if (global.is_host)
{
	//Simple player-tracking Ai
	var _p = instance_nearest(x, y, PLAYER);
	
	if (_p != noone)
		motion_add_custom(point_direction(x, y, _p.x, _p.y), 0.1);
		
	calculate_collisions();
	
	//Check for death
	if (hp <= 0)
		instance_destroy();
}

event_inherited();