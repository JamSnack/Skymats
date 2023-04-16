/// @description Insert description here
// You can write your code in this editor

if (global.game_state == "LOAD")
	exit;

key_left  =  keyboard_check(ord("A"));
key_up    =  keyboard_check(ord("W"));
key_right =  keyboard_check(ord("D"));

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
	
if !(on_ground != noone && on_ground.object_index == obj_platform) && collision_line(bbox_right+1, bbox_top, bbox_right+1, bbox_bottom, obj_platform, false, true) == noone
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
		show_debug_message("Hooking a mob");
		grapple_point_x = grappling_to.x;
		grapple_point_y = grappling_to.y;
	}
	else if (!instance_exists(grappling_to))
	{
		grappling = false;
		grapple_is_launching = false;
	}
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
			if (obj_platform.powered && obj_platform.fuel > 2)
				grapple_point_y = obj_platform.y;
		} else grapple_point_x += SCROLL_SPEED;
	}
}

if (grapple_launch_length > stat_grapple_range)
	grapple_is_launching = false;


grapple_launch_length = point_distance(x, y, grapple_point_x, grapple_point_y);

//Control angle
if (grapple_is_launching || grappling)
	draw_angle = lerp(draw_angle, point_direction(x, y, grapple_point_x, grapple_point_y)-90, 0.25);
else if (vspd > 2)
	draw_angle = lerp(draw_angle, point_direction(x, y, x+hspd, y+vspd)-90, 0.1);
else
	draw_angle = lerp(draw_angle, 0, 0.2);
	

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
				hp -= other.stat_mine_level;
				
				draw_damage = true;
				damage = (hp/max_hp)*7;
				
				if (hp <= 0)
				{
					instance_destroy();
					event_user(0);
				}
			}
		}
		else if (global.multiplayer)
		{
			//Hurt the tile for visual purposes
			with _tile
				hp -= other.stat_mine_level;
				
			send_data({cmd: "request_tile_hit", damage: stat_mine_level, x: mouse_x, y: mouse_y});	
		}
		
		mine_cooldown = stat_mine_cooldown;
	}
}
else if (mine_cooldown > 0) mine_cooldown--;

//Tile placement
if (client_can_place_tile && global.inventory.selected_slot != -1)
{
	var tile_selected = global.inventory.contents[_selected_slot];
	var object_selected = get_tile_object_from_item(tile_selected.item_id);
	var _x = get_coordinate_on_world_grid(mouse_x+8);
	var _y = get_coordinate_on_world_grid(mouse_y+8);
	
	if (point_distance(x, y, _x, _y) < 16*5 && tile_selected.amount > 0 &&  object_selected != -1 && mouse_check_button(mb_left) && collision_point(_x, _y, OBSTA, false, true) == noone)
	{
		if (global.is_host)
		{
			instance_create_layer(_x, _y, "Instances", object_selected);
			global.inventory.subtractItemAtSlot(_selected_slot, 1);
		}
		else
		{
			send_data({cmd: "request_create_tile", x: _x, y: _y, item_id: tile_selected.item_id});
			client_can_place_tile = false;
		}
	}
}

//Jetpack
if (key_up && jetpack_fuel > 0 && jetpack_init_delay <= 0)
{
	if (vspd > 0)
		vspd = approach(vspd, 0, 0.175);
	
	jetpack_fuel -= 1;
	//show_debug_message(stat_jetpack_strength);
	jetpack_regen_cooldown = stat_jetpack_cooldown;
	motion_add_custom(90, stat_jetpack_strength);
}
else if (on_ground == noone && jetpack_init_delay > 0)
	jetpack_init_delay--;
else if (on_ground != noone)
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
		if (collision_line(x, y, _e.x, _e.y, TILE, false, true) == noone)
		{
			//Weapon dooldown
			weapon_cooldown = stat_weapon_cooldown;
		
			//knockback direction
			var dir_knock = point_direction(x, y, _e.x, _e.y);
		
			//Deal damage and apply knockback
			if (global.is_host)
			{
				hurt_enemy(_e, dir_knock, stat_weapon_knockback, stat_weapon_damage);
			}
			else send_data({cmd: "request_enemy_hurt", connected_id: _e.connected_id, damage: stat_weapon_damage, dir_knock: dir_knock, knock_amt: stat_weapon_knockback});
		
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
	var _struct = {cmd: "player_pos", x: x, y: y, id: global.client_id};
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