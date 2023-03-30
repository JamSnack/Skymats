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
	var _s = {cmd: "enemy_pos", x: x, y: y, connected_id: connected_id, hp: hp};
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


//Personal tile culling
//This should happen because we just deactivated all tiles and we need to make sure enemies don't clip into things
if (global.is_host == true && tile_culling_delay <= 0)
{
	var _boundary = 16*4;
	instance_activate_region(x-_boundary, y-_boundary, _boundary, _boundary, true);
	
	tile_culling_delay = 10;
} else if tile_culling_delay > 0
	tile_culling_delay--;