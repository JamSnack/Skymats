/// @description Insert description here
// You can write your code in this editor
key_left  =  keyboard_check(ord("A"));
key_up    =  keyboard_check(ord("W")) || keyboard_check(vk_space);
key_right =  keyboard_check(ord("D"));
key_down  =  keyboard_check(ord("S"));
key_shift =	 keyboard_check(vk_lshift) || keyboard_check(vk_rshift);

hmove = (key_right - key_left);
var on_ground = noone;
var true_speed = (abs(hspd)+abs(vspd)); 

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
	motion_add_custom(point_direction(x, y, grapple_point_x, grapple_point_y), stat_grapple_force);
	grapple_launch_length = point_distance(x, y, grapple_point_x, grapple_point_y);
	
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
			if (obj_platform.powered && obj_platform.fuel > 2 && !obj_platform.obstruction)
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
	if (vspd > 0)
		vspd = lerp(vspd, 0, 0.1);
	
	//Regen jetpack fuel
	jetpack_regen_cooldown = 0;
	
	//If the player goes underneath the world, drain hp quickly
	if (y > WORLD_BOUND_BOTTOM + 384)
		hp -= 0.05;
}
	
//Tile mininig
var _selected_slot = global.inventory.selected_slot;

if (_selected_slot == -1 && mine_cooldown <= 0 && point_distance(x, y, mouse_x, mouse_y) < 64 && mouse_check_button(mb_left))
{
	_tile = collision_point(mouse_x, mouse_y, TILE, false, true)
	
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
				
				send_data({cmd: "request_tile_hit", damage: other.stat_mine_level, owner_id: owner.connected_id, x: grid_pos.x, y: grid_pos.y});
			}
		}
		
		mine_cooldown = stat_mine_cooldown;
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
			jetpack_fuel -= 1;
		}
		
		//Vertical jetpack
		if (key_up)
			motion_add_custom(90, stat_jetpack_strength);
		else if (key_down)
			motion_add_custom(270, stat_jetpack_strength);
		
		//Horizontal jetpack
		if (key_right)
			motion_add_custom(0, stat_jetpack_strength);
			
		else if (key_left)
			motion_add_custom(180, stat_jetpack_strength);
	}
	
	//Remove fuel
	if ((key_shift && (key_right || key_left || key_up || key_down)))
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

//Instant cooldown
if (on_ground != noone || grappling)
	jetpack_regen_cooldown = 0;

//Auto-Attack
if (weapon_cooldown > 0)
{
	var bonus_cooldown = true_speed*0.1;
	weapon_cooldown -= (1 + bonus_cooldown);
}
	
if (instance_exists(ENEMY) && weapon_cooldown <= 0)
{
	var _e = collision_circle(x, y, stat_weapon_range, ENEMY, false, true);
	
	//Hit the nearby mob
	if (_e != noone)
	{
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
			hurt_enemy(_e, dir_knock, stat_weapon_knockback + bonus_knockback, stat_weapon_damage + bonus_attack);
			
			if (!global.is_host && global.multiplayer)
				send_data({cmd: "request_enemy_hurt", connected_id: _e.connected_id, damage: stat_weapon_damage + bonus_attack, dir_knock: dir_knock, knock_amt: stat_weapon_knockback + bonus_knockback});
		
			//Hit effect
			instance_create_layer(x+lengthdir_x(4, dir_knock), y+lengthdir_y(4, dir_knock), "Instances", efct_attack, {image_angle: dir_knock});
		}
	}
}

//Death
if (hp <= 0 && !dead)
{
	dead = true;
	x = obj_market.x;
	y = obj_market.y;
	hspd = 0;
	vspd = 0;
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
		can_hurt_delay = 10;
	}
}