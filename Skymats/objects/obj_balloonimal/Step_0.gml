if (global.is_host)
{
	motion_add_custom(90, 0.1);
	motion_add_custom(180*sin((x+current_time)/1000), 0.01);
	
	calculate_collisions();
	
	clamp_speed(-max_hspeed, max_hspeed, -max_vspeed, 5);
}

if (lifespan <= 0)
	instance_destroy();
else lifespan--;

event_inherited();