//host stuff
if (!global.is_host)
{ 
	sync_position();
	
	//Rid ourselves of falsehood.
	if (x == xprevious && y == yprevious)
		kill_timer--;
	else
		kill_timer = 60*2;
		
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

event_inherited();