motion_add_custom(90, 0.1);
motion_add_custom(180*sin((x+current_time)/500), 0.01);
	
calculate_collisions();
	
clamp_speed(-max_hspeed, max_hspeed, -max_vspeed, 5);

//Wraps around height
if (y < WORLD_BOUND_TOP-16)
{
	y = VOID_BOUND_BOTTOM+16;
	
	with (obj_player)
		if (grappling_to == other.id) { grappling_to = noone; }
}

if (y > WORLD_BOUND_TOP+16)
	keep_in_bounds();

/*
if (lifespan <= 0)
	instance_destroy();
else lifespan--;
*/

event_inherited();