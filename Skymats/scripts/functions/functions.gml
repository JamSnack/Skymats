   // Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

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
#macro SCROLL_CONDITIONS global.tutorial_complete

#macro ENEMY_CAP 15
#macro INVASION_START_CONDITIONS (instance_number(ENEMY) < ENEMY_CAP)

global.can_grapple = true;
global.can_jetpack = true;
global.stored_resources = array_create(ITEM_ID.last, 0);
global.stored_resources_unlocked = array_create(ITEM_ID.last, 0);
global.stored_resources_auto_burn = array_create(ITEM_ID.last, 0);
global.stored_resource_to_burn = 1;
//(!instance_exists(obj_client_request_chunk) && !instance_exists(obj_chunk_loader) && !instance_exists(obj_island_generator) && !instance_exists(obj_client_request_chunk))

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
	x = lerp(x, target_x, 0.2);
	y = lerp(y, target_y, 0.2);
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
			{
				drop_item = true;
				instance_destroy();
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
	//show_debug_message(height);
	//Color 1 is higher than Color 2.
	//As the player falls, Color 1 will approach Color 2.
	//As the player rises, Color 2 will approach Color 1.
	if (height < 1000)
		return [[86/255, 135/255, 1.0, 1.0],[0.0, 0.0, 0.1, 1.0]];
	else if (height >= 1000 && height < 5000)
		return [[86/255, 135/255, 1.0, 1.0], [86/255, 135/255, 1.0, 1.0]];
	
	else if (height >= 5000 && height < 6000)
		return [[89/255, 113/255, 249/255, 1.0], [86/255, 135/255, 1.0, 1.0]];
	
	else if (height >= 6000 && height < 7000)
		return [[89/255, 113/255, 249/255, 1.0], [89/255, 113/255, 249/255, 1.0]];
		
	else if (height >= 7000 && height < 8000)
		return [[255/255, 248/255, 127/255, 1.0], [89/255, 113/255, 249/255, 1.0]]; //Tier 1 to Tier 2
		
	else if (height >= 8000 && height < 9000)
		return [[225/255, 124/255, 10/255, 1.0], [255/255, 248/255, 127/255, 1.0]]; //Tier 2 to Tier 2.1
		
	else if (height >= 9000 && height < 13000)
		return [[225/255, 124/255, 10/255, 1.0], [225/255, 124/255, 10/255, 1.0]];
	
	else if (height >= 13000 && height < 14000)
		return [[168/255, 0, 56/255, 1.0],[225/255, 124/255, 10/255, 1.0]]; //Tier 2.1 to Tier 2.2
		
	else if (height >= 14000 && height < 15000)
		return [[0.0, 0, 0.1, 1.0], [168/255, 0, 56/255, 1.0]]; //Tier 2.2 to Space
		
	else if (height >= 15000)
		return [[0.0, 0, 0.1, 1.0],[0.0, 0, 0.1, 1.0]];
	
	//Default colors
	return [[0.0, 0, 0, 1.0],[0.0, 0.0, 0.1, 1.0]]; //Void
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

function save_character(username = "character")
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
				player_level: player_level,
				username: username
			}
				
			var json = json_stringify(save_struct);
			var _buff = buffer_create(string_byte_length(json) + 1, buffer_fixed, 1);
			buffer_write(_buff, buffer_string, json);
			buffer_save(_buff, string(username)+".charc");
	
			//cleanup
			buffer_delete(_buff);
		}
	}
}

function save_expedition(expedition_name = "exped")
{
	if (instance_exists(obj_platform))
	{
		with (obj_platform)
		{
			var save_struct = {
				platform_height: global.platform_height,
				tutorial_complete: global.tutorial_complete,
				stored_resources: global.stored_resources,
				stored_resources_unlocked: global.stored_resources_unlocked,
				auto_burn: global.stored_resources_auto_burn,
				burning: global.stored_resource_to_burn
			}
				
			var json = json_stringify(save_struct);
			var _buff = buffer_create(string_byte_length(json) + 1, buffer_fixed, 1);
			buffer_write(_buff, buffer_string, json);
			buffer_save(_buff, string(expedition_name)+".exped");
	
			//cleanup
			buffer_delete(_buff);
		}
	}
}

function save_game()
{
	if (instance_exists(obj_player))
		save_character(obj_player.username);
		
	save_expedition(networkingControl.exped_name);
	
	instance_create_layer(x, y, "Instances", efct_game_save);
}

function load_character(file)
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
			username = _data.username;
			player_level = _data.player_level;
		}
		catch (e)
		{
			show_debug_message("Error loading file");
			show_debug_message(e);
		}
	}
}


function read_character(file)
{
	if (file_exists(file))
	{
		var _buff = buffer_load(file);	
		var _string = buffer_read(_buff, buffer_string);
		var _data = json_parse(_string);
	
		try
		{
			var data_struct = 
			{
				/*
				stat_grapple_force : _data.stat_grapple_force,
				stat_grapple_speed : _data.stat_grapple_speed,
				stat_grapple_range : _data.stat_grapple_range,

				//- mining tool
				stat_mine_level : _data.stat_mine_level, 
				stat_mine_cooldown : _data.stat_mine_cooldown, 

				//- jetpack
				stat_jetpack_fuel : _data.stat_jetpack_fuel, 
				stat_jetpack_strength : _data.stat_jetpack_strength,
				stat_jetpack_cooldown : _data.stat_jetpack_cooldown,
				stat_jetpack_regen_rate : _data.stat_jetpack_regen_rate,

				//- weapon
				stat_weapon_cooldown : _data.stat_weapon_cooldown, 
				stat_weapon_damage : _data.stat_weapon_damage,
				stat_weapon_knockback : _data.stat_weapon_knockback,
				stat_weapon_range : _data.stat_weapon_range,
	
				//Purchase
				upgrades_purchased : _data.upgrades_purchased,*/
				gold : _data.gold,
				player_level : _data.player_level,
				username: _data.username
			}
			
			return data_struct;
		}
		catch (e)
		{
			return -1;
			show_debug_message("Error loading file");
			show_debug_message(e);
		}
	}
}



function load_expedition(file)
{
	if (file_exists(file))
	{
		var _buff = buffer_load(file);	
		var _string = buffer_read(_buff, buffer_string);
		var _data = json_parse(_string);
	
		try
		{
			//Platform
			global.platform_height = _data.platform_height;
			global.tutorial_complete = _data.tutorial_complete;
			global.stored_resources = _data.stored_resources;
			global.stored_resources_unlocked = _data.stored_resources_unlocked;
			global.stored_resources_auto_burn = _data.auto_burn;
			global.stored_resource_to_burn = _data.burning;
		}
		catch (e)
		{
			show_debug_message("Error loading file");
			show_debug_message(e);
		}
	}
}


// Read the expedition file and load its contents into a file object
function read_expedition(file)
{
	if (file_exists(file))
	{
		
		var _buff = buffer_load(file);	
		var _string = buffer_read(_buff, buffer_string);
		var _data = json_parse(_string);
	
		try
		{
			var _c = get_background_colors(-_data.platform_height);
			
			var data_struct = 
			{
				platform_height : _data.platform_height,
				tutorial_complete : _data.tutorial_complete,
				colors : [make_color_rgb(_c[0][0]*255, _c[0][1]*255, _c[0][2]*255), make_color_rgb(_c[1][0]*255, _c[1][1]*255, _c[1][2]*255)],
				resources_discovered : 0
			}
			
			for (var _i = 0; _i < ITEM_ID.last; _i++)
			{
				if (_data.stored_resources_unlocked[_i])
					data_struct.resources_discovered++;
			}
			
			return data_struct;
		}
		catch (e)
		{
			show_debug_message("Error reading file");
			show_debug_message(e);
			return -1;
		}
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