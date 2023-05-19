//Simple player-tracking Ai
var _p = instance_nearest(x, y, PLAYER);
	
if (_p != noone)
	motion_add_custom(point_direction(x, y, _p.x + random_factor*10, _p.y + random_factor*10), 0.1);
		
calculate_collisions();
target_x += hspd;
target_y += vspd;
	
//Speed clamp
clamp_speed(-max_hspeed, max_hspeed, -max_vspeed, max_vspeed);


event_inherited();