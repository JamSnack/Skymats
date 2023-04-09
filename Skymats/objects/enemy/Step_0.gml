//host stuff
if (global.is_host)
{
	//Check for death
	if (hp <= 0)
		instance_destroy();
	
	//multiplayer
	if (current_time mod 2 == 0)
	{
		var _s = {cmd: "enemy_pos", x: x, y: y, connected_id: connected_id, hp: hp, object: object_index};
		send_data(_s);
	}
}
else
{ 
	sync_position();
	
	//Rid ourselves of falsehood.
	if (x == xprevious && y == yprevious)
		kill_timer--;
	else
		kill_timer = 60*5;
		
	if (kill_timer <= 0)
		instance_destroy();
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
	var _boundary = 16*2;
	instance_activate_region(x-_boundary + hspd, y-_boundary + vspd, _boundary*4 + hspd, _boundary*4 + vspd, true);
	
	tile_culling_delay = 0;
} else if tile_culling_delay > 0
	tile_culling_delay--;