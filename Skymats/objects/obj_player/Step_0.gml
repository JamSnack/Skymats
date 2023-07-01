/// @description Insert description here
// You can write your code in this editor
key_left  =  keyboard_check(ord("A"));
key_up    =  keyboard_check(ord("W")) || keyboard_check(vk_space);
key_right =  keyboard_check(ord("D"));
key_down  =  keyboard_check(ord("S"));
key_shift =	 keyboard_check(vk_lshift) || keyboard_check(vk_rshift);

hmove = (key_right - key_left);
var on_ground = noone;

if (vspd >= 0)
	on_ground = collision_line(bbox_left, bbox_bottom+1, bbox_right, bbox_bottom+1, OBSTA, false, true);
//var vmove = (key_down  -   key_up);

//Increase speed based on movement
if (on_ground != noone)
	hspd = approach(hspd, hmove*max_walkspeed, 0.25);
else
	hspd = approach(hspd, hmove*max_walkspeed, 0.1);
	
if (SCROLL_CONDITIONS) && !(on_ground != noone && on_ground.object_index == obj_platform) && collision_line(bbox_right+1, bbox_top, bbox_right+1, bbox_bottom, obj_platform, false, true) == noone
	x += SCROLL_SPEED;

//Gravity
vspd += GRAVITY*weight;

var true_speed = (abs(hspd)+abs(vspd)); 

//Jump
if (key_up && collision_rectangle(bbox_left, bbox_top+2, bbox_right, bbox_bottom+2, OBSTA, false, true) != noone)
{
	//vspd = -2.5;
	motion_add_custom(90, 2.5);
	audio_play_standard(snd_jump, 9, false, true);
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
	var direction_to_grapple_point = point_direction(x, y, grapple_point_x, grapple_point_y);
	
	motion_add_custom(direction_to_grapple_point, stat_grapple_force);
		
	grapple_launch_length = point_distance(x, y, grapple_point_x, grapple_point_y);
	
	//Control grapple_length
	if (grapple_launch_length > stat_grapple_range)
	{
		var _tx = grapple_point_x - lengthdir_x(stat_grapple_range, direction_to_grapple_point);
		var _ty = grapple_point_y - lengthdir_y(stat_grapple_range, direction_to_grapple_point);
		
		if (!place_meeting(_tx, _ty, OBSTA))
		{
			x = _tx;
			y = _ty;
		}
		
		motion_add_custom(direction_to_grapple_point, 1);
	}
	
	//Keep hook on moving enemies
	if (instance_exists(grappling_to) && object_get_parent(grappling_to.object_index) == ENEMY)
	{
		//show_debug_message("Hooking a mob");
		grapple_point_x = grappling_to.x;
		grapple_point_y = grappling_to.y;
	}
	else if (!instance_exists(grappling_to))
	{
		grappling = false;
		grapple_is_launching = false;
	}
}

if (mouse_check_button(mb_right) && global.can_grapple)
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
	var _c = collision_line(grapple_point_x, grapple_point_y, grapple_point_x + lengthdir_x(grapple_speed, grapple_direction), grapple_point_y + lengthdir_y(grapple_speed, grapple_direction), GRAPPLEABLE, true, true);
	
	if (_c != noone)
	{
		grappling_to = _c;
		
		//Grab onto the outside of a tile or set grapple to an enemy point
		if (_c.object_index == TILE)
		{
			var _r = 0;
			while (collision_line(grapple_point_x, grapple_point_y, grapple_point_x + lengthdir_x(1, grapple_direction), grapple_point_y + lengthdir_y(1, grapple_direction), GRAPPLEABLE, true, true) == noone)
			{
				grapple_point_x += lengthdir_x(1, grapple_direction);
				grapple_point_y += lengthdir_y(1, grapple_direction);
				_r += 1;
			
				if (_r > grapple_speed)
					break;
			}
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
else if (grappling)
{
	if (instance_exists(grappling_to))
	{
		if (grappling_to.object_index == obj_platform)
		{
			if (obj_platform.powered && obj_platform.fuel > 2 && !obj_platform.obstruction && !obj_platform.waiting_for_pilot && !obj_platform.approach_dungeon)
				grapple_point_y -= 1;
		} else if (SCROLL_CONDITIONS) grapple_point_x += SCROLL_SPEED;
	}
}

if (grapple_launch_length > stat_grapple_range)
	grapple_is_launching = false;


grapple_launch_length = point_distance(x, y, grapple_point_x, grapple_point_y);

//Control angle
if (grapple_is_launching || grappling)
	draw_angle = lerp(draw_angle, point_direction(x, y, grapple_point_x, grapple_point_y)-90, 0.25);
else if (vspd > 2 || true_speed > 2 && key_shift)
	draw_angle = lerp(draw_angle, point_direction(x, y, x+hspd, y+vspd)-90, 0.1);
else
	draw_angle = lerp(draw_angle, 0, 0.2);
	

//Stay in-bounds
if (y <= WORLD_BOUND_BOTTOM)
	keep_in_bounds();
else
{
	//We have entered the void
	if (vspd > 3)
		vspd = lerp(vspd, 0, 0.1); //Quickly reduce speed
	else if (vspd != 0)
	{
		vspd -= GRAVITY*weight; //remove gravity calculation
		vspd = lerp(vspd, 0, 0.02); //Slight resistance
	}
	
	//Regen jetpack fuel
	jetpack_regen_cooldown = 0;
	
	//If the player goes underneath the world, drain hp quickly
	if (y > VOID_BOUND_BOTTOM)
		hp -= 0.05;
		
	//Allow void-swimming
	if (key_right)
		motion_add_custom(0, 0.1);
	else if (key_left)
		motion_add_custom(180, 0.1);
		
	if (key_up)
		motion_add_custom(90, 0.1);
	else if (key_down)
		motion_add_custom(270, 0.1);
}
	
//Tile mininig
//var _selected_slot = global.inventory.selected_slot;

//Mining Visuals
mine_laser_distance = min(point_distance(x, y, mouse_x, mouse_y), 64);
mine_laser_direction = point_direction(x, y, mouse_x, mouse_y);

var mine_x = x + lengthdir_x(mine_laser_distance, mine_laser_direction);
var mine_y = y + lengthdir_y(mine_laser_distance, mine_laser_direction);

if (mouse_check_button(mb_left))
{
	//effects
	part_particles_create(global.foreground_particles_fixed, mine_x, mine_y, global.particle_library.mining_spark, 2);
}

_tile = collision_point(mine_x, mine_y, TILE, false, true);

//mining functionality
if (mine_cooldown <= 0 && mouse_check_button(mb_left))
{
	if (_tile != noone && _tile.tile_level <= stat_mine_level)
	{
		if (global.is_host)
		{
			//Hurt the tile and destroy it with server authority
			with _tile
			{
				hurt_tile(other.stat_mine_level);
				
				draw_damage = true;
				damage = (hp/max_hp)*7;
				
				if (hp <= 0)
					event_user(0);
			}
		}
		else if (global.multiplayer && instance_exists(_tile.owner))
		{
			//Hurt the tile for visual purposes
			with _tile
			{
				hurt_tile(other.stat_mine_level);
				
				if (hp <= 0)
					event_user(0);
				
				send_data({cmd: "request_tile_hit", damage: other.stat_mine_level, owner_id: owner.connected_id, x: grid_pos.x, y: grid_pos.y});
			}
		}
		
		mine_cooldown = stat_mine_cooldown;
	}
	
	//Deal mining damage to enemies
	_mob = collision_line_list(x, y, mine_x, mine_y, ENEMY, false, true, enemy_hurt_list_mining, false);

	if (_mob > 0 && collision_line(x, y, mine_x, mine_y, OBSTA, false, true) == noone)
	{
		for (var _m = 0; _m < _mob; _m++)
		{
			var _inst = enemy_hurt_list_mining[| _m];
			hurt_enemy(_inst, mine_laser_direction, 1, 1, 0);
			
			//Sync mining laser damage
			if (!global.is_host && global.multiplayer)
				send_data({cmd: "request_enemy_hurt", connected_id: _inst.connected_id, damage: 1, bonus_atk: 0, dir_knock: mine_laser_direction, knock_amt: 1});
		}
		
		mine_cooldown = stat_mine_cooldown/2;
		
		//reset
		ds_list_clear(enemy_hurt_list_mining);
	}
}
else if (mine_cooldown > 0) mine_cooldown--;

//Jetpack
if (global.can_jetpack && jetpack_fuel > 0 && jetpack_init_delay <= 0)
{
	//Apply force
	if (key_shift)
	{
		//Stabilize
		if (vspd > 0 && !key_down)
		{
			vspd = approach(vspd, 0, 0.175 + stat_jetpack_strength*0.01);
			
			create_smoke(x - (3*image_xscale), y + 5, -90, 2);
		}
		
		//Calculate Speed limit
		var _limit = 2 + stat_jetpack_strength*20;
		var _pivot_strength = 0.2;
		
		//Vertical jetpack
		if (key_up && vspd > -_limit)
			motion_add_custom(90, stat_jetpack_strength);
		else if (key_down && vspd < _limit)
			motion_add_custom(270, stat_jetpack_strength);
		
		//Horizontal jetpack
		if (key_right && hspd < _limit)
		{
			if (hspd < -2)
				hspd = approach(hspd, -2, _pivot_strength);
				
			motion_add_custom(0, stat_jetpack_strength);
		}
		else if (key_left && hspd > -_limit)
		{
			if (hspd > 2)
				hspd = approach(hspd, 2, _pivot_strength);
				
			motion_add_custom(180, stat_jetpack_strength);
		}
	}
	
	//Remove fuel
	if (key_shift)
	{
		jetpack_fuel -= 1;
		jetpack_regen_cooldown = stat_jetpack_cooldown;
		
		//effects
		if (key_up)
			create_smoke(x - (3*image_xscale), y + 5, -90, 4);
		else if (key_down)
			create_smoke(x - (3*image_xscale), y + 5, 90, 4);
			
		if (key_left)
			create_smoke(x - (3*image_xscale), y + 5, 0, 4);
		else if (key_right)
			create_smoke(x - (3*image_xscale), y + 5, 180, 4);
	}
}
else if (on_ground == noone && jetpack_init_delay > 0)
	jetpack_init_delay--;
else if (on_ground != noone)
	jetpack_init_delay = jetpack_set_init_delay;


//Jetpack cooldown
if (jetpack_regen_cooldown > 0)
	jetpack_regen_cooldown--;
else if (!key_shift && jetpack_fuel < stat_jetpack_fuel)
{
	//Player receives more fuel the longer they are under certain conditions
	jetpack_fuel += jetpack_refuel_rate;
	jetpack_refuel_rate = lerp(jetpack_refuel_rate, stat_jetpack_regen_rate + (stat_jetpack_regen_rate*2)*(on_ground != noone) + (stat_jetpack_regen_rate*2)*(grappling), 0.1);
}

//Animation
jetpack_fuel_draw = lerp(jetpack_fuel_draw, jetpack_fuel, 0.05);

//Instant cooldown
if (on_ground != noone || grappling)
	jetpack_regen_cooldown = 0;

//Auto-Attack
if (weapon_cooldown > 0)
{
	var bonus_cooldown = true_speed*0.1;
	weapon_cooldown -= (1 + bonus_cooldown);
	
	//effects
	if (weapon_cooldown <= 0)
		audio_play_sound_custom(snd_charged, 10, false);
}
	
if (instance_exists(ENEMY) && distance_to_object(instance_nearest(x, y, ENEMY)) <= stat_weapon_range && weapon_cooldown <= 0)
{
	var _amt = collision_circle_list(x, y, stat_weapon_range, ENEMY, false, true, enemy_hurt_list, false);
	
	//Hit the nearby mob
	if (_amt > 0)
	{
		for (var _i = 0; _i < _amt; _i++)
		{
			var _e = enemy_hurt_list[| _i];
			
			if (collision_line(x, y, _e.x, _e.y, TILE, false, true) == noone)
			{
				//Speed bonuses
			
				var bonus_knockback = true_speed/2;
				var bonus_attack = round(true_speed/2);
			
				//Weapon dooldown
				weapon_cooldown = stat_weapon_cooldown;
		
				//knockback direction
				var dir_knock = point_direction(x, y, _e.x, _e.y);
		
				//Deal damage and apply knockback
				hurt_enemy(_e, dir_knock, stat_weapon_knockback + bonus_knockback, stat_weapon_damage, bonus_attack);
			
				if (!global.is_host && global.multiplayer)
					send_data({cmd: "request_enemy_hurt", connected_id: _e.connected_id, damage: stat_weapon_damage, bonus_atk: bonus_attack, dir_knock: dir_knock, knock_amt: stat_weapon_knockback + bonus_knockback});
		
				//Hit effect
				instance_create_layer(x+lengthdir_x(4, dir_knock), y+lengthdir_y(4, dir_knock), "Instances", efct_attack, {image_angle: dir_knock});
			}
		}
	}
	
	ds_list_clear(enemy_hurt_list);
}

//Death
if (hp <= 0 && !dead)
{
	dead = true;
	x = obj_market.x;
	y = obj_market.y;
	hspd = 0;
	vspd = 0;
	grappling = false;
	grappling_to = noone;
	obj_chat_box.add("[c_red]Someone died!");
	
	//Empty inventory
	global.inventory.clear();
}
else if (dead && respawn_delay > 0)
	respawn_delay--;
else if (dead)
{
	hp = max_hp;
	dead = false;
	respawn_delay = 60;
}

//Send coordinates
if ((x != xprevious || y != yprevious) && global.client_id != -1 && global.multiplayer && position_update_delay == 0)
{
	var _struct = {cmd: "player_pos", x: x, y: y, id: global.client_id, angle: draw_angle, jetpack: (key_shift && global.can_jetpack && jetpack_fuel > 0 && jetpack_init_delay <= 0), gx: grapple_point_x, gy: grapple_point_y, gd: grapple_direction, gg: (grappling || grapple_is_launching)};
	send_data(_struct);
	position_update_delay = 3;
}
else if position_update_delay > 0
	position_update_delay--;
	
//clamp speeds
clamp_speed(-32, 32, -32, 32);

//Sprite control
if (grapple_is_launching)
{
	sprite_index = spr_player_hook;
	image_index = lerp(image_index, 5, 0.1);
}
else if (grappling)
{
	sprite_index = spr_player_hook;
	image_index = 5;
}
else if (on_ground != noone && hspd != 0)
{
	sprite_index = spr_player_run;
	image_speed = hspd/2;
}
else if (on_ground == noone)
{
	if (vspd < 0)
	{
		sprite_index = spr_player_jump;
		image_index = lerp(image_index, 5, 0.1);
	}
	else
	{
		sprite_index = spr_player_fall;
		image_speed = vspd/2;
	}
}
else sprite_index = spr_player_idle;

update_shadow(shadow);
layer_sprite_angle(shadow, draw_angle); //special for player

//Can hurt
if (!can_hurt)
{
	can_hurt_delay--;
	
	if (can_hurt_delay <= 0)
	{
		can_hurt = true;
		can_hurt_delay = 30;
	}
}

//Hurt effect
if (hurt_effect != 0)
	hurt_effect = approach(hurt_effect, 0, 0.1);
	
//Healthbar animation
draw_hp = lerp(draw_hp, hp, 0.3);
draw_hp_red = lerp(draw_hp_red, hp, 0.1);