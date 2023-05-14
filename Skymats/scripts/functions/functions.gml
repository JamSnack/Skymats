  // Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

#macro GRAVITY 0.1
#macro WORLD_BOUND_LEFT 0
#macro WORLD_BOUND_RIGHT room_width
#macro WORLD_BOUND_TOP global.platform_height
#macro WORLD_BOUND_BOTTOM room_height + global.platform_height

#macro CHUNK_WIDTH 683
#macro CHUNK_HEIGHT 384

#macro SCROLL_SPEED 0.2
#macro SCROLL_CONDITIONS global.tutorial_complete

#macro ENEMY_CAP 15
#macro INVASION_START_CONDITIONS (instance_number(ENEMY) < ENEMY_CAP)

global.can_grapple = true;
global.can_jetpack = true;
global.stored_resources = array_create(ITEM_ID.last, 0);
global.stored_resources_unlocked = array_create(ITEM_ID.last, 0);
//(!instance_exists(obj_client_request_chunk) && !instance_exists(obj_chunk_loader) && !instance_exists(obj_island_generator) && !instance_exists(obj_client_request_chunk))

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

function create_floating_text(x, y, text, color)
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
	x = lerp(x, target_x, 0.33);
	y = lerp(y, target_y, 0.33);
}

function hurt_tile(_damage)
{
	hp -= _damage;
	
	create_floating_text(mouse_x, mouse_y, _damage, c_red);
	
	draw_damage = true;
	damage = (hp/max_hp)*7;
	
	if (hp <= 0)
		instance_destroy();
	
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

function hurt_enemy(inst, k_direction, k_amt, damage)
{
	if (instance_exists(inst))
	{
		with (inst)
		{
			motion_add_custom(k_direction, max(k_amt-weight, 0));
			hp -= damage;
			
			create_floating_text(x, y, damage, c_red);
			
			if (hp <= 0)
				instance_destroy();
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
			default: { return 5 + 25*(_up*(_up-1)) + power(2, _up-1); } break;
		}
	}
	else return noone;
}

function apply_upgrade(upgrade_id)
{
	if (instance_exists(obj_player))
	{
		var _up = obj_player.upgrades_purchased[upgrade_id];
	
		switch (upgrade_id)
		{
			case UPGRADE.grapple_range:		{ obj_player.stat_grapple_range = 100 + 25*_up; } break;
			case UPGRADE.grapple_travel:	{ obj_player.stat_grapple_speed = 6 + 2*_up; } break;
			case UPGRADE.grapple_strength:  { obj_player.stat_grapple_force = 0.25 + 0.05*_up; } break;
											 
			case UPGRADE.mine_strength:	    { obj_player.stat_mine_level    = 1 + 0.5*_up; } break;
			case UPGRADE.mine_speed:		{ obj_player.stat_mine_cooldown = 45 - 4*_up; } break;
											 
			case UPGRADE.jetpack_fuel:		{ obj_player.stat_jetpack_fuel = 70 + _up*30; } break;
			case UPGRADE.jetpack_force:		{ obj_player.stat_jetpack_strength    = 0.15 + _up*0.025; } break;
			case UPGRADE.jetpack_cooldown:	{ obj_player.stat_jetpack_cooldown    = 90 + -10*_up; } break;
			case UPGRADE.jetpack_regen_rate:{ obj_player.stat_jetpack_regen_rate  = 0.2 + _up*0.05; } break;
											  
			case UPGRADE.weapon_speed:		{ obj_player.stat_weapon_cooldown   = 100 - 10*_up; } break;
			case UPGRADE.weapon_damage:		{ obj_player.stat_weapon_damage     = _up; } break;
			case UPGRADE.weapon_range:		{ obj_player.stat_weapon_range      = 24 + _up; } break;
			case UPGRADE.weapon_knockback:  { obj_player.stat_weapon_knockback  = 5 + _up; } break;
		}
	}
}

function init_player()
{
	weapon_cooldown = stat_weapon_cooldown
	
	jetpack_fuel = stat_jetpack_fuel;
	jetpack_regen_cooldown = stat_jetpack_cooldown;
	jetpack_set_init_delay = 15; 
	jetpack_init_delay = jetpack_set_init_delay; //How long it takes for the jetpack to be usable after leaving the ground
}


function get_background_colors(height)
{
	//show_debug_message(height);
	//Color 1 is higher than Color 2.
	//As the player falls, Color 1 will approach Color 2.
	//As the player rises, Color 2 will approach Color 1.
	if (height <= 8000 && height > 7000)
		return [[86/255, 135/255, 1.0, 1.0], [86/255, 135/255, 1.0, 1.0]]; //Void to Tier 1
	else if (height <= 7000 && height > 6000)
		return [[89/255, 113/255, 249/255, 1.0], [86/255, 135/255, 1.0, 1.0]]; //Tier 1 to Tier 1
	else if (height <= 6000 && height > 5000)
		return [[255/255, 248/255, 127/255, 1.0], [89/255, 113/255, 249/255, 1.0]]; //Tier 1 to Tier 2
	else if (height <= 5000 && height > 4000)
		return [[225/255, 124/255, 10/255, 1.0], [255/255, 248/255, 127/255, 1.0]]; //Tier 2 to Tier 2.1
	else if (height <= 4000 && height > 3000)
		return [[168/255, 0, 56/255, 1.0],[225/255, 124/255, 10/255, 1.0]]; //Tier 2.1 to Tier 2.2
	else if (height <= 3000 && height > 2000)
		return [[225/255, 124/255, 10/255, 1.0], [0.0, 1/255, 20/255, 1.0]]; //Tier 2.2 to Space
	else if (height <= 2000 && height > 1000)
		return [[0.0, 1/255, 20/255, 1.0],[0.0, 0, 0, 1.0]]; //Space to Deep Space
	else if (height <= 1000 && height > 0)
		return [[0.0, 0, 0, 1.0],[0.75, 0.75, 0.75, 1.0]]; //Deep Space to Sky
	
	//Default colors
	return [[86/255, 135/255, 1.0, 1.0],[0.0, 0.0, 0.1, 1.0]]; //Void
}

function draw_shadow(sprite_index, image_index, x_offset, y_offset, image_xscale, image_yscale, image_angle, color, image_alpha)
{
	draw_sprite_ext(sprite_index, image_index, x + x_offset, y + y_offset, image_xscale, image_yscale, image_angle, color, image_alpha);
}

function create_shadow()
{
	var shadow = layer_sprite_create("Shadows", x+2, y+2, sprite_index);
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

function update_shadow(shadow)
{
	if (layer_sprite_exists("Shadows", shadow))
	{
		layer_sprite_x(shadow, x+2); //assuming offset of 2 for now
		layer_sprite_y(shadow, y+2);
		layer_sprite_index(shadow, image_index);
		layer_sprite_change(shadow, sprite_index);
		layer_sprite_angle(shadow, image_angle);
		layer_sprite_xscale(shadow, image_xscale);
		layer_sprite_yscale(shadow, image_yscale);
	}
}

function save_game()
{
	if (instance_exists(obj_player))
	{
		with (obj_player)
		{
			var save_struct = {
				stat_grapple_force: stat_grapple_force,
				stat_grapple_range: stat_grapple_range,
				stat_grapple_speed: stat_grapple_speed,
					
				stat_jetpack_cooldown: stat_jetpack_cooldown,
				stat_jetpack_fuel: stat_jetpack_fuel,
				stat_jetpack_regen_rate: stat_jetpack_regen_rate,
				stat_jetpack_strength: stat_jetpack_strength,
					
				stat_mine_cooldown: stat_mine_cooldown,
				stat_mine_level: stat_mine_level,
					
				stat_weapon_cooldown: stat_weapon_cooldown,
				stat_weapon_damage: stat_weapon_damage,
				stat_weapon_knockback: stat_weapon_knockback,
				stat_weapon_range: stat_weapon_range,
					
				upgrades_purchased: upgrades_purchased,
				gold: gold,
					
				platform_height: global.platform_height,
				tutorial_complete: global.tutorial_complete
			}
				
			var json = json_stringify(save_struct);
			var _buff = buffer_create(string_byte_length(json) + 1, buffer_fixed, 1);
			buffer_write(_buff, buffer_string, json);
			buffer_save(_buff, "test.data");
	
			//cleanup
			buffer_delete(_buff);
		}
	}
}

function load_game(file)
{
	if (file_exists(file))
	{
		var _buff = buffer_load(file);	
		var _string = buffer_read(_buff, buffer_string);
		var _data = json_parse(_string);
	
		try
		{
			stat_grapple_force = _data.stat_grapple_force; //How much force is applied to the player +0.5
			stat_grapple_speed = _data.stat_grapple_speed; //How fast the hook travels +2
			stat_grapple_range = _data.stat_grapple_range; //How far the hook can go (600 is about the edge of the screen) +20

			//- mining tool
			stat_mine_level = _data.stat_mine_level; //Determines which blocks can be destroyed and not
			stat_mine_cooldown = _data.stat_mine_cooldown; //Determines how much time must pass before the pickaxe can be swung again

			//- jetpack
			stat_jetpack_fuel = _data.stat_jetpack_fuel; //How many frames can pass before the jetpack runs out of fuel. +30
			stat_jetpack_strength = _data.stat_jetpack_strength; //How fast the jetpack boosts you + 0.025
			stat_jetpack_cooldown = _data.stat_jetpack_cooldown; //How many frames of inactivity need to pass before the jetpack fuel begins regenerating -10
			stat_jetpack_regen_rate = _data.stat_jetpack_regen_rate; //How much jetpack fuel regenerates each frame. +0.05

			//- weapon
			stat_weapon_cooldown = _data.stat_weapon_cooldown; //How many frames it takes to prepare the auto-attack
			stat_weapon_damage = _data.stat_weapon_damage;
			stat_weapon_knockback = _data.stat_weapon_knockback;
			stat_weapon_range = _data.stat_weapon_range;
	
			//Purchase
			upgrades_purchased = _data.upgrades_purchased;
			gold = _data.gold;
		
			//Platform
			global.platform_height = _data.platform_height;
			global.tutorial_complete = _data.tutorial_complete;
		}
		catch (e)
		{
			show_debug_message("Error loading file");
			show_debug_message(e);
		}
	}
}

function init_game()
{
	global.platform_height = 0;
	global.tutorial_complete = false;
}