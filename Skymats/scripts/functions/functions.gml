     // Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
global.dungeon = false;

#macro GRAVITY 0.1
#macro WORLD_BOUND_LEFT 0
#macro WORLD_BOUND_RIGHT room_width
#macro WORLD_BOUND_TOP global.platform_height
#macro WORLD_BOUND_BOTTOM room_height + global.platform_height

#macro ISLAND_MARKER_OFFSET_X 16*5
#macro ISLAND_MARKER_OFFSET_Y -16*4

#macro CHUNK_WIDTH 683
#macro CHUNK_HEIGHT 384

#macro SCROLL_SPEED 0.2
#macro SCROLL_CONDITIONS global.tutorial_complete && !global.dungeon

#macro ENEMY_CAP 15
#macro INVASION_START_CONDITIONS (instance_number(ENEMY) < ENEMY_CAP)

global.can_grapple = true;
global.can_jetpack = true;
global.stored_resources = array_create(ITEM_ID.last, 0);
global.stored_resources_unlocked = array_create(ITEM_ID.last, 0);
global.stored_resources_auto_burn = array_create(ITEM_ID.last, 0);
global.stored_resource_to_burn = 1;

//(!instance_exists(obj_client_request_chunk) && !instance_exists(obj_chunk_loader) && !instance_exists(obj_island_generator) && !instance_exists(obj_client_request_chunk))

function string_split(str, delimiter)
{
	var r;
	
	if (argument_count >= 3)
	{
	    r = argument[2];
	    ds_list_clear(r);
	} 
	else r = ds_list_create();
	
	var p = string_pos(delimiter, str), o = 1;
	var dl = string_length(delimiter);
	if (dl) while (p) {
	    ds_list_add(r, string_copy(str, o, p - o));
	    o = p + dl;
	    p = string_pos_ext(delimiter, str, o);
	}
	
	ds_list_add(r, string_delete(str, 1, o - 1));
	
	return r;
}

function init_dungeon_load()
{
	with (TILE)
		instance_destroy();
	
	if (instance_exists(obj_platform))
	{
		obj_platform.approach_dungeon = true;
		global.dungeon = true;
	}
	
}

function create_sprite_shatter(x, y, amount, sprite, speed, direction, weight)
{
	repeat(amount)
	{
		var _i = instance_create_layer(x, y, "Instances", efct_sprite_piece, {sprite: sprite, speed: speed, direction: direction + irandom_range(-10, 10)});
		_i.left = irandom(sprite_get_width(sprite)/2);
		_i.top = irandom(sprite_get_height(sprite)/2);
		_i.width = irandom(sprite_get_width(sprite)/2);
		_i.height = irandom(sprite_get_height(sprite)/2);
		_i.gravity = weight+GRAVITY;
		//_i.friction = weight*0.1;
	}
}

function create_smoke(x, y, direction, speed)
{
	instance_create_layer(x, y, "Instances", efct_smoke, {direction: direction, speed: speed});
}

function keep_in_bounds()
{
	if (x > WORLD_BOUND_RIGHT)
		motion_add_custom(180, 1);
	
	else if (x < WORLD_BOUND_LEFT)
		motion_add_custom(0, 1);
	
	if (y < WORLD_BOUND_TOP)
		motion_add_custom(270, 1);
	
	else if (y > WORLD_BOUND_BOTTOM)
		motion_add_custom(90, 1);
}

function create_notification(text)
{
	instance_create_layer(0, 0, "Instances", efct_notification, {text: text});
}

function create_floating_text(x, y, text, color="[c_white]")
{
	instance_create_layer(x, y, "Instances", efct_floating_text, {text: text, color: color});
}

function create_depot(x, y, item_id)
{
	instance_create_layer(x, y, "Instances", efct_depot, {image_index: item_id});
}

function approach(a, b, amt)
{
	if (a < b)
	    return min(a + amt, b); 
	else
	    return max(a - amt, b);	
}

function sync_position()
{
	x = lerp(x, target_x, 0.2);
	y = lerp(y, target_y, 0.2);
}

function hurt_tile(_damage)
{
	hp -= _damage;
	
	draw_damage = true;
	damage = (hp/max_hp)*7;
	
	if (hp <= 0)
	{
		instance_destroy();
		create_sprite_shatter(x, y, 6 + irandom(4), sprite_index, 2, 90, 0);
	}
	
	if (global.multiplayer && global.is_host && instance_exists(owner))
	{
		send_data({cmd: "update_tile_hp", owner_id: owner.connected_id, x: grid_pos.x, y: grid_pos.y, hp: hp});
	}
}

function audio_play_standard(sound, priority, loops, overwrites=false)
{
	if (overwrites)
		if (audio_is_playing(sound))
			audio_stop_sound(sound);
	
	audio_play_sound(sound, priority, loops);
}

function hurt_enemy(inst, k_direction, k_amt, damage, bonus_damage)
{
	if (instance_exists(inst))
	{
		with (inst)
		{
			motion_add_custom(k_direction, max(k_amt-weight, 0));
			
			var true_damage = damage+bonus_damage;
			
			hp -= true_damage;
			hit_effect = 1;
			
			
			
			if (bonus_damage >= 6)
			{
				create_floating_text(x, y, "[wobble][pulse][scale, 1.5]"+string(true_damage), "[rainbow][spr_ui_star]");
				part_particles_create(global.foreground_particles_fixed, x, y, global.particle_library.hit_effect3, 2);
				audio_play_sound_custom(snd_star_crit, 10, false);
			}
			else if (bonus_damage >= 3)
			{
				create_floating_text(x, y, "[wobble][pulse]"+string(true_damage), "[c_red]");
				part_particles_create(global.foreground_particles_fixed, x, y, global.particle_library.hit_effect2, 2);
				audio_play_sound_custom(snd_red_crit, 10, false);
			}
			else 
			{
				create_floating_text(x, y, "[wobble][pulse][scale, 0.5]"+string(true_damage), "[c_orange]");
				part_particles_create(global.foreground_particles_fixed, x, y, global.particle_library.hit_effect1, 2);
				audio_play_sound_custom(snd_default_hit, 10, false);
			}
			
			if (hp <= 0)
			{
				drop_item = true;
				instance_destroy();
				create_sprite_shatter(x, y, 2 + irandom(2), sprite_index, irandom(2) + k_amt/3, k_direction, weight);
				create_smoke(x, y, k_direction, 1);
				
				if (instance_exists(obj_player))
					obj_player.jetpack_fuel += obj_player.stat_jetpack_fuel*0.1;
			}
		}
	}
}

function calculate_collisions()
{
	//Horizontal collision
	if (collision_rectangle(bbox_left + hspd, bbox_top, bbox_right + hspd, bbox_bottom, OBSTA, false, true) != noone)
	{
		var _h = (hspd > 0) ? min(sign(hspd), hspd) : max(sign(hspd), hspd);
	
		while (collision_rectangle(bbox_left + _h, bbox_top, bbox_right + _h, bbox_bottom, OBSTA, false, true) == noone)
		{
			x += _h;
		}
	
		hspd = -hspd*bounciness;
	}
	else x += hspd;

	//Vertcial Collision
	if (collision_rectangle(bbox_left, bbox_top + vspd, bbox_right, bbox_bottom + vspd, OBSTA, false, true) != noone)
	{
		var _v = (vspd > 0) ? min(1, vspd) : max(-1, vspd);
	
		while (collision_rectangle(bbox_left, bbox_top + _v, bbox_right, bbox_bottom + _v, OBSTA, false, true) == noone)
		{
			y += _v;
		}
		
		vspd = -vspd*bounciness;
	} else y += vspd;	
}

function clamp_speed(min_hspd, max_hspd, min_vspd, max_vspd)
{
	hspd = clamp(hspd, min_hspd, max_hspd);
	vspd = clamp(vspd, min_vspd, max_vspd);
}

function sync_chunks()
{
	if (!global.is_host)
		send_data({cmd: "request_init_island_markers"});
}

function motion_add_custom(_direction, _speed)
{
	//init vector for use in proceeding speed calculations
	direction = _direction;
	speed = _speed;
	
	//apply speed at some direction to homemode variables
	hspd += hspeed;
	vspd += vspeed;
	
	//reset
	speed = 0;
}

function tile_is_adjacent(x, y, object)
{
	var left  = collision_point(x - 16, y,       object, false, true);
	var right = collision_point(x + 16, y,       object, false, true);
	var top   = collision_point(x,      y - 16,  object, false, true);
	var down  = collision_point(x,      y + 16 , object, false, true);
	
	var _r = choose(1, 2, 3, 4);
	
	switch (_r)
	{
		case 1:
		{
			if (left != noone)
				return left;
			else if (right != noone)
				return right;
			else if (top != noone)
				return top;
			else if (down != noone)
				return down;
		}
		break;
		
		case 2:
		{
			if (right != noone)
				return right;
			else if (left != noone)
				return left;
			else if (top != noone)
				return top;
			else if (down != noone)
				return down;
		}
		break;
		
		case 3:
		{
			if (top != noone)
				return top;
			else if (down != noone)
				return down;
			else if (left != noone)
				return left;
			else if (right != noone)
				return right;
		}
		break;
		
		case 4:
		{
			if (down != noone)
				return down;
			else if (top != noone)
				return top;
			else if (left != noone)
				return left;
			else if (right != noone)
				return right;
		}
		break;
	}

	return noone;
}	


enum UPGRADE
{
	none,
	grapple_range,
	grapple_travel,
	grapple_strength,
	
	mine_strength,
	mine_speed,
	
	weapon_speed,
	weapon_damage,
	weapon_range,
	weapon_knockback,
	
	jetpack_fuel,
	jetpack_force,
	jetpack_cooldown,
	jetpack_regen_rate,
	
	last
}

function get_upgrade_cost(upgrade_id)
{
	if (instance_exists(obj_player))
	{
		var _up = obj_player.upgrades_purchased[upgrade_id];
		
		switch (upgrade_id)
		{/*
			case UPGRADE.grapple_range:		{ return power(5, _up); } break;
			case UPGRADE.grapple_travel:	{ return power(5, _up); } break;
			case UPGRADE.grapple_strength:  { return power(5, _up); } break;
															  
			case UPGRADE.mine_strength:	    { return power(5, _up); } break;
			case UPGRADE.mine_speed:		{ return power(5, _up); } break;
															  
			case UPGRADE.jetpack_fuel:		{ return power(5, _up); } break;
			case UPGRADE.jetpack_force:		{ return power(5, _up); } break;
			case UPGRADE.jetpack_cooldown:	{ return power(5, _up); } break;
			case UPGRADE.jetpack_regen_rate:{ return power(5, _up); } break;
															  
			case UPGRADE.weapon_speed:		{ return power(5, _up); } break;
			case UPGRADE.weapon_damage:		{ return power(5, _up); } break;
			case UPGRADE.weapon_range:		{ return power(5, _up); } break;
			case UPGRADE.weapon_knockback:  { return power(5, _up); } break;
			*/
			default: { return 50 + 35*(_up*(_up-1)) + power(3, _up-1); } break;
		}
	}
	else return noone;
}

function apply_upgrade(upgrade_id)
{
	if (instance_exists(obj_player))
	{
		var _up = obj_player.upgrades_purchased[upgrade_id]-1;
	
		switch (upgrade_id)
		{
			case UPGRADE.grapple_range:		{ obj_player.stat_grapple_range = 100 + 15*_up; } break;
			case UPGRADE.grapple_travel:	{ obj_player.stat_grapple_speed = 6 + _up; } break;
			case UPGRADE.grapple_strength:  { obj_player.stat_grapple_force = 0.20 + 0.025*_up; } break;
											 
			case UPGRADE.mine_strength:	    { obj_player.stat_mine_level    = 1 + 0.5*_up; } break;
			case UPGRADE.mine_speed:		{ obj_player.stat_mine_cooldown = 45 - 3*_up; } break;
											 
			case UPGRADE.jetpack_fuel:		{ obj_player.stat_jetpack_fuel = 55 + _up*8; } break;
			case UPGRADE.jetpack_force:		{ obj_player.stat_jetpack_strength    = 0.13 + _up*0.0175; } break;
			case UPGRADE.jetpack_cooldown:	{ obj_player.stat_jetpack_cooldown    = 90 + -10*_up; } break;
			case UPGRADE.jetpack_regen_rate:{ obj_player.stat_jetpack_regen_rate  = 0.2 + _up*0.05; } break;
											  
			case UPGRADE.weapon_speed:		{ obj_player.stat_weapon_cooldown   = 120 - 10*_up; } break;
			case UPGRADE.weapon_damage:		{ obj_player.stat_weapon_damage     = 1 + _up; } break;
			case UPGRADE.weapon_range:		{ obj_player.stat_weapon_range      = 24 + _up; } break;
			case UPGRADE.weapon_knockback:  { obj_player.stat_weapon_knockback  = 4 + _up; } break;
		}
	}
}

function init_player()
{
	var _i = 1;
	repeat(UPGRADE.last-1)
		apply_upgrade(_i++);
}

function calculate_player_level()
{
	var _l = 0;
	for (var k=0; k < UPGRADE.last; k++)
		_l += obj_player.upgrades_purchased[k];
	
	return _l - UPGRADE.last;
}

function init_player_stats()
{
	//Stats
	weapon_cooldown = 0;
	
	jetpack_fuel = 0;
	jetpack_regen_cooldown = 0;
	jetpack_set_init_delay = 0; 
	jetpack_init_delay = 0; //How long it takes for the jetpack to be usable after leaving the ground

	//- grapple
	stat_grapple_force = 0.25; //How much force is applied to the player +0.5
	stat_grapple_speed = 6; //How fast the hook travels +2
	stat_grapple_range = 100; //How far the hook can go (600 is about the edge of the screen) +20

	//- mining tool
	stat_mine_level = 1; //Determines which blocks can be destroyed and not
	stat_mine_cooldown = 45; //Determines how much time must pass before the pickaxe can be swung again

	//- jetpack
	stat_jetpack_fuel = 70; //How many frames can pass before the jetpack runs out of fuel. +30
	stat_jetpack_strength = 0.15; //How fast the jetpack boosts you + 0.025
	stat_jetpack_cooldown = 90; //How many frames of inactivity need to pass before the jetpack fuel begins regenerating -10
	stat_jetpack_regen_rate = 0.2; //How much jetpack fuel regenerates each frame. +0.05
	jetpack_refuel_rate = 0; //How much fuel the jetpack will receive in the next tick.

	//- weapon
	stat_weapon_cooldown = 100; //How many frames it takes to prepare the auto-attack
	stat_weapon_damage = 1;
	stat_weapon_knockback = 6;
	stat_weapon_range = 28;
	
	player_level = 0;
}


function get_background_colors(height)
{
	//Color 1 is higher than Color 2.
	//As the player falls, Color 1 will approach Color 2.
	//As the player rises, Color 2 will approach Color 1.
	if (height < 1000)
		return [[86/255, 135/255, 1.0, 1.0],[0.0, 0.0, 0.1, 1.0], 1000];
	else if (height >= 1000 && height < 5000)
		return [[86/255, 135/255, 1.0, 1.0], [86/255, 135/255, 1.0, 1.0], 4000];
	
	else if (height >= 5000 && height < 6000)
		return [[89/255, 113/255, 249/255, 1.0], [86/255, 135/255, 1.0, 1.0], 1000];
	
	else if (height >= 6000 && height < 7000)
		return [[89/255, 113/255, 249/255, 1.0], [89/255, 113/255, 249/255, 1.0], 1000];
		
	else if (height >= 7000 && height < 8000)
		return [[255/255, 248/255, 127/255, 1.0], [89/255, 113/255, 249/255, 1.0], 1000]; //Tier 1 to Tier 2
		
	else if (height >= 8000 && height < 9000)
		return [[225/255, 124/255, 10/255, 1.0], [255/255, 248/255, 127/255, 1.0], 1000]; //Tier 2 to Tier 2.1
		
	else if (height >= 9000 && height < 13000)
		return [[225/255, 124/255, 10/255, 1.0], [225/255, 124/255, 10/255, 1.0], 4000];
	
	else if (height >= 13000 && height < 14000)
		return [[168/255, 0, 56/255, 1.0],[225/255, 124/255, 10/255, 1.0], 1000]; //Tier 2.1 to Tier 2.2
		
	else if (height >= 14000 && height < 15000)
		return [[0.0, 0, 0.1, 1.0], [168/255, 0, 56/255, 1.0], 1000]; //Tier 2.2 to Space
		
	else if (height >= 15000)
		return [[0.0, 0, 0.1, 1.0],[0.0, 0, 0.1, 1.0], 1];
	
	//Default colors
	return [[0.0, 0, 0, 1.0],[0.0, 0.0, 0.1, 1.0], 1000]; //Void
}

function draw_shadow(sprite_index, image_index, x_offset, y_offset, image_xscale, image_yscale, image_angle, color, image_alpha)
{
	draw_sprite_ext(sprite_index, image_index, x + x_offset, y + y_offset, image_xscale, image_yscale, image_angle, color, image_alpha);
}

function create_shadow()
{
	var shadow = layer_sprite_create("Shadows", x+1, y+1, sprite_index);
	layer_sprite_alpha(shadow, 0.5);
	layer_sprite_blend(shadow, c_black);
	layer_sprite_index(shadow, image_index);
	
	return shadow;
}

function destroy_shadow(shadow)
{
	if (layer_sprite_exists("Shadows", shadow))
		layer_sprite_destroy(shadow);
}

function update_shadow(shadow, angle = image_angle)
{
	if (layer_sprite_exists("Shadows", shadow))
	{
		layer_sprite_x(shadow, x+2); //assuming offset of 2 for now
		layer_sprite_y(shadow, y+2);
		layer_sprite_index(shadow, image_index);
		layer_sprite_change(shadow, sprite_index);
		layer_sprite_angle(shadow, angle);
		layer_sprite_xscale(shadow, image_xscale);
		layer_sprite_yscale(shadow, image_yscale);
	}
}


/*function load_game(character_file, expedition_file)
{
	load_character(character_file);
	load_expedition(expedition_file);
}*/

function init_expedition()
{
	global.platform_height = 0;
	global.tutorial_complete = false;
	
	//global.can_grapple = false;
	//global.can_jetpack = false;
	//global.stored_resources = array_create(ITEM_ID.last, 0);
	//global.stored_resources_unlocked = array_create(ITEM_ID.last, 0);
	//global.stored_resources_auto_burn = array_create(ITEM_ID.last, 0);
}

function world_to_gui_coords(x, y)
{
	return { 
		x: (x-camera_get_view_x(view_camera[0]))*(display_get_gui_width()/camera_get_view_width(view_camera[0])),
		y: (y-camera_get_view_y(view_camera[0]))*(display_get_gui_height()/camera_get_view_height(view_camera[0]))
	}
}

function instance_destroy_safe(instance)
{
	if (instance_exists(instance))
	{
		with (instance)
		{
			instance_destroy();
		}
	}
}

function draw_sprite_outlined_ext(sprite_index, image_index, x, y, outline_color, xscale, yscale, angle, image_alpha)
{
	//This script currently only supports white outlines. See shd_whiteout for deatils.
	
	//set shader
	gpu_set_fog(true, c_white, 0, 1);

	//Outline color
	draw_sprite_ext(sprite_index, image_index, x+xscale, y+yscale, xscale, yscale, angle, outline_color, image_alpha);  
	draw_sprite_ext(sprite_index, image_index, x-xscale, y-yscale, xscale, yscale, angle, outline_color, image_alpha);    
	draw_sprite_ext(sprite_index, image_index, x       , y+yscale, xscale, yscale, angle, outline_color, image_alpha);    
	draw_sprite_ext(sprite_index, image_index, x+xscale, y       , xscale, yscale, angle, outline_color, image_alpha);   
	draw_sprite_ext(sprite_index, image_index, x       , y-yscale, xscale, yscale, angle, outline_color, image_alpha);    
	draw_sprite_ext(sprite_index, image_index, x-xscale, y       , xscale, yscale, angle, outline_color, image_alpha);   
	draw_sprite_ext(sprite_index, image_index, x-xscale, y+yscale, xscale, yscale, angle, outline_color, image_alpha);    
	draw_sprite_ext(sprite_index, image_index, x+xscale, y-yscale, xscale, yscale, angle, outline_color, image_alpha);    
	
	//reset
	gpu_set_fog(false, c_white, 0, 0);
  
	//Draw sprite on-top of outline color
	draw_sprite_ext(sprite_index, image_index, x, y, xscale, yscale, angle, c_white, image_alpha);
}