/// @description Insert description here
// You can write your code in this editor

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
				global.platform_height += _d*10;
			
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








