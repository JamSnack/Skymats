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
	var _c = instance_place(x, y, obj_player);
	
	with _c
	{
		motion_add_custom(point_direction(other.x, other.y, x, y), other.knockback);
		hp -= other.damage;
		can_hurt = false;
		hurt_effect = 1;
		death_instance_watching = other.id;
	}
}

//Hit stuff
if (hit_effect != 0)
	hit_effect = approach(hit_effect, 0, 0.1);

//hp bar
if (hp_bar_red != hp/max_hp)
	hp_bar_red = lerp(hp_bar_red, hp/max_hp, 0.05);

//Update shadow
update_shadow(shadow, draw_angle);