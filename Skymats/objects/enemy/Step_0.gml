if (global.is_host)
{
	//Simple player-tracking Ai
	var _p = instance_nearest(x, y, PLAYER);
	
	if (_p != noone)
		motion_add_custom(point_direction(x, y, _p.x, _p.y), 0.1);
	
	clamp_speed(-4, 4, -4, 4);
	calculate_collisions();
	
	//Check for death
	if (hp <= 0)
		instance_destroy();
	
	//multiplayer
	var _s = {cmd: "enemy_pos", x: x, y: y, connected_id: connected_id};
	send_data(_s);
}
else
{
	sync_position();	
}


//Check for damage outside of global.is_host condition
var _c = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true);
	
if (_c != noone)
{
	with _c
	{
		motion_add_custom(point_direction(other.x, other.y, x, y), other.knockback);
		hp -= other.damage;
	}
}