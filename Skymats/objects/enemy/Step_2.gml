/// @description Insert description here
// You can write your code in this editor

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

//hp bar
if (hp_bar_red != hp/max_hp)
	hp_bar_red = lerp(hp_bar_red, hp/max_hp, 0.05);

//Update shadow
update_shadow(shadow, draw_angle);



// Hit the platform
if (instance_exists(obj_platform))
{
	if (can_hurt_skymat && place_meeting(x+hspd, y+vspd, obj_platform))
	{
		drop_item = false;
		cash_to_drop = 0;
		instance_destroy();
	
		// hurt the skymat
		var _d = damage;
		with (obj_platform)
		{
			if (fuel <= 0)
				global.platform_height += _d*5;
			
			fuel = approach(fuel, 0, _d);
			powered = false;
		}
		
		// sound
		audio_play_sound_custom(snd_charged, 10, false);
		audio_play_sound_in_world(snd_default_hit, 10, false, false, x, y);
		
		// effect
		instance_create_layer(x, y, "Instances", efct_attack, {image_angle: random(359)});
	}
}








