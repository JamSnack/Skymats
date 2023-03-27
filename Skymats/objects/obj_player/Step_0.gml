/// @description Insert description here
// You can write your code in this editor

key_left  =  keyboard_check(ord("A"));
key_up    =  keyboard_check(ord("W"));
key_down  =  keyboard_check(ord("S"));
key_right =  keyboard_check(ord("D"));

var hmove = (key_right - key_left);
var on_ground = (collision_point(x, bbox_bottom+1, OBSTA, false, true) != noone);
//var vmove = (key_down  -   key_up);

//Increase speed based on movement
if (on_ground)
	hspd = approach(hspd, hmove*max_walkspeed, 0.25);
else
	hspd = approach(hspd, hmove*max_walkspeed, 0.1);

//Gravity
vspd += GRAVITY*weight;

//Jump
if (key_up && collision_rectangle(bbox_left, bbox_top+2, bbox_right, bbox_bottom+2, OBSTA, false, true) != noone)
{
	//vspd = -2.5;
	motion_add_custom(90, 2.5);
}

//Collision
calculate_collisions();

//sprite
if (hmove != 0)
	image_xscale = hmove;


//Grappling hook
false_angle = point_direction(x, y, mouse_x, mouse_y);

if (grappling)
{
	motion_add_custom(point_direction(x, y, grapple_point_x, grapple_point_y), stat_grapple_force);
	grapple_launch_length = point_distance(x, y, grapple_point_x, grapple_point_y);
}

if (mouse_check_button(mb_right))
{
	if (!grapple_is_launching && !grappling && grapple_launch_length <= 4)
	{
		grapple_is_launching = true;
		grapple_direction = false_angle;
		grapple_target_point_x = mouse_x;
		grapple_target_point_y = mouse_y;
	}
}
else
{
	grappling = false;
	grapple_is_launching = false;
}

if (grapple_is_launching)
{
	var grapple_speed = stat_grapple_speed;
	var _c = collision_line(grapple_point_x, grapple_point_y, grapple_point_x + lengthdir_x(grapple_speed, grapple_direction), grapple_point_y + lengthdir_y(grapple_speed, grapple_direction), OBSTA, true, true);
	
	if (_c != noone)
	{
		var _r = 0;
		while (collision_line(grapple_point_x, grapple_point_y, grapple_point_x + lengthdir_x(1, grapple_direction), grapple_point_y + lengthdir_y(1, grapple_direction), OBSTA, true, true) == noone)
		{
			grapple_point_x += lengthdir_x(1, grapple_direction);
			grapple_point_y += lengthdir_y(1, grapple_direction);
			_r += 1;
			
			if (_r > grapple_speed)
				break;
		}
		
		grappling = true;
		grapple_is_launching = false;
	}
	else
	{
		grapple_point_x += lengthdir_x(grapple_speed, grapple_direction);
		grapple_point_y += lengthdir_y(grapple_speed, grapple_direction);		
	}
}
else if (!grappling)
{
	grapple_point_x = x;
	grapple_point_y = y;
}

if (grapple_launch_length > stat_grapple_range)
	grapple_is_launching = false;


grapple_launch_length = point_distance(x, y, grapple_point_x, grapple_point_y);


//Stay in-bounds
if (x > WORLD_BOUND_RIGHT)
	motion_add_custom(180, 1);
	
if (x < WORLD_BOUND_LEFT)
	motion_add_custom(0, 1);
	
if (y < WORLD_BOUND_TOP)
	motion_add_custom(270, 1);
	
if (y > WORLD_BOUND_BOTTOM)
	motion_add_custom(90, 1);
	
//Tile mininig
if (mine_cooldown <= 0 && point_distance(x, y, mouse_x, mouse_y) < 64 && mouse_check_button(mb_left))
{
	_tile = collision_point(mouse_x, mouse_y, OBSTA, false, true)
	
	if (_tile != noone && _tile.tile_level <= stat_mine_level)
	{
		if (global.is_host)
		{
			with _tile
			{
				instance_destroy();
				event_user(0);
			}
		}
		else if (global.multiplayer)
		{
			send_data({cmd: "request_tile_hit", x: mouse_x, y: mouse_y});	
		}
		
		mine_cooldown = stat_mine_cooldown;
	}
}
else if (mine_cooldown > 0) mine_cooldown--;

//Jetpack
if (key_up && jetpack_fuel > 0 && jetpack_init_delay <= 0)
{
	jetpack_fuel -= 1;
	jetpack_regen_cooldown = stat_jetpack_cooldown;
	motion_add_custom(90, stat_jetpack_strength);
}
else if (!on_ground && jetpack_init_delay > 0)
	jetpack_init_delay--;
else if (on_ground)
	jetpack_init_delay = jetpack_set_init_delay;

if (jetpack_regen_cooldown > 0)
	jetpack_regen_cooldown--;
else if (jetpack_fuel < stat_jetpack_fuel)
{
	jetpack_fuel += stat_jetpack_regen_rate;	
}

//Auto-Attack
if (weapon_cooldown > 0)
	weapon_cooldown--;
	
if (instance_exists(ENEMY) && weapon_cooldown <= 0)
{
	var _e = collision_circle(x, y, stat_weapon_range, ENEMY, false, true);
	
	//Hit the nearby mob
	if (_e != noone)
	{
		//Deal damange
		_e.hp -= stat_weapon_damage;
		
		//Weapon dooldown
		weapon_cooldown = stat_weapon_cooldown;
		
		//knockback
		var dir_knock = point_direction(x, y, _e.x, _e.y);
		
		with (_e)
			motion_add_custom(dir_knock, other.stat_weapon_knockback);
		
		//Hit effect
		instance_create_layer(x+lengthdir_x(4, dir_knock), y+lengthdir_y(4, dir_knock), "Instances", efct_attack, {image_angle: dir_knock});
	}
}

//Death
if (hp <= 0)
{
	hp = max_hp;
	x = 1432;
	y = 3392;
}

//Send coordinates
if (global.client_id != -1 && global.multiplayer && current_time mod 4 == 0)
{
	var _struct = {cmd: "player_pos", x: x, y: y, id: global.client_id};
	send_data(_struct);
}