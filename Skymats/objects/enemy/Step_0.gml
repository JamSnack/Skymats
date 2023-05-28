//host stuff
if (!global.is_host)
{ 
	if (!clientside_physics)
		sync_position();
	
	//Rid ourselves of falsehood.
	/*
	if (x == xprevious && y == yprevious)
		kill_timer--;
	else
		kill_timer = 60*2;
		
	if (kill_timer <= 0)
		instance_destroy();
	*/
}
else if (sync_timer < 0)
{
	send_enemy_position();
	sync_timer = 1;
}
else sync_timer--;

//Check for damage outside of global.is_host condition
if (instance_exists(obj_player) && obj_player.can_hurt)
{
	var _c = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true);
	
	if (_c != noone)
	{
		with _c
		{
			motion_add_custom(point_direction(other.x, other.y, x, y), other.knockback);
			hp -= other.damage;
			can_hurt = false;
			hurt_effect = 1;
		}
	}
}

//Hit stuff
if (hit_effect != 0)
	hit_effect = approach(hit_effect, 0, 0.1);

//Update shadow
update_shadow(shadow, draw_angle);