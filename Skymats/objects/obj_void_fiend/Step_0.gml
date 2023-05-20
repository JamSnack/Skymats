//Simple player-tracking Ai
var _p = instance_nearest(x, y, PLAYER);
	
if (_p != noone && _p.y > WORLD_BOUND_BOTTOM-100)
	motion_add_custom(point_direction(x, y, _p.x + random_factor*10, _p.y + random_factor*10), 0.25);
else motion_add_custom(270, 0.1);
		
calculate_collisions();
target_x += hspd;
target_y += vspd;

//Keep in the void
if (y < WORLD_BOUND_BOTTOM)
{
	//show_debug_message(WORLD_BOUND_BOTTOM);
	motion_add_custom(270, 1);
}
	
//Speed clamp
clamp_speed(-max_hspeed, max_hspeed, -max_vspeed, max_vspeed);

//image angle
image_angle = point_direction(x, y, x+hspd, y+vspd);


event_inherited();