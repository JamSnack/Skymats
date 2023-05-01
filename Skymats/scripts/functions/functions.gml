// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

#macro GRAVITY 0.1
#macro WORLD_BOUND_LEFT 0
#macro WORLD_BOUND_RIGHT room_width
#macro WORLD_BOUND_TOP global.platform_height
#macro WORLD_BOUND_BOTTOM room_height + global.platform_height

#macro CHUNK_WIDTH 683
#macro CHUNK_HEIGHT 384

#macro SCROLL_SPEED 0.1
#macro SCROLL_CONDITIONS true
//(!instance_exists(obj_client_request_chunk) && !instance_exists(obj_chunk_loader) && !instance_exists(obj_island_generator) && !instance_exists(obj_client_request_chunk))

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
		var _v = (vspd > 0) ? min(sign(vspd), vspd) : max(sign(vspd), vspd);
	
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
	{
		send_data({cmd: "request_init_island_markers"});
		//instance_create_layer(WORLD_BOUND_LEFT, WORLD_BOUND_TOP, "Instances", obj_client_request_chunk);
		/*
		instance_create_layer(x, y-CHUNK_HEIGHT, "Instances", obj_client_request_chunk);
		instance_create_layer(x, y+CHUNK_HEIGHT, "Instances", obj_client_request_chunk);
		instance_create_layer(x+CHUNK_WIDTH, y, "Instances", obj_client_request_chunk);
		instance_create_layer(x, y, "Instances", obj_client_request_chunk);
		
		
		for (var _i = 0; _i < 3; _i++)
			instance_create_layer(x-CHUNK_WIDTH + CHUNK_WIDTH*_i, y, "Instances", obj_client_request_chunk);
		
		for (var _i = 0; _i < 3; _i++)
			instance_create_layer(x-CHUNK_WIDTH + CHUNK_WIDTH*_i, y-CHUNK_HEIGHT, "Instances", obj_client_request_chunk);
		
		for (var _i = 0; _i < 3; _i++)
			instance_create_layer(x-CHUNK_WIDTH + CHUNK_WIDTH*_i, y+CHUNK_HEIGHT, "Instances", obj_client_request_chunk);
			*/
	}
}

function get_item_name(item_id)
{
	
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

function get_tile_object_from_item(item_id)
{
	switch item_id
	{
		case ITEM_ID.grass:        { return obj_grass;    } break;
		case ITEM_ID.stone:        { return obj_stone;    } break;
		case ITEM_ID.coal:         { return obj_coal;     } break;
		case ITEM_ID.iron:         { return obj_iron;     } break;
		case ITEM_ID.copper:       { return obj_copper;   } break;
		case ITEM_ID.silver:       { return obj_silver;   } break;
		case ITEM_ID.gold:         { return obj_gold;     } break;
		case ITEM_ID.sapphire:     { return obj_sapphire; } break;
		case ITEM_ID.ruby:         { return obj_ruby;     } break;
		case ITEM_ID.emerald:      { return obj_emerald;  } break;
		case ITEM_ID.diamond:      { return obj_diamond;  } break;
		case ITEM_ID.pot_of_greed: { return obj_pot_of_greed; } break;
		
		default:			 { return obj_bedrock; } break;
	}
}

function get_item_value(item_id)
{
	switch item_id
	{
		case ITEM_ID.grass:		   { return  1; } break;
		case ITEM_ID.stone:		   { return  1; } break;
		case ITEM_ID.coal:         { return  2; } break;
		case ITEM_ID.copper:	   { return  3; } break;
		case ITEM_ID.iron:	       { return  4; } break;
		case ITEM_ID.silver:	   { return  5; } break;
		case ITEM_ID.gold:		   { return  7; } break;
		case ITEM_ID.sapphire:	   { return  10; } break;
		case ITEM_ID.ruby:		   { return  14; } break;
		case ITEM_ID.emerald:	   { return  21; } break;
		case ITEM_ID.diamond:	   { return  27; } break;
		case ITEM_ID.enemy_parts:  { return  5; } break;
		case ITEM_ID.pot_of_greed: { return  250; } break;
		default:				   { return -1; } break;
	}
}

function get_coordinate_on_world_grid(x)
{
	return floor(x/16)*16;
}

function item(_name = "", _item_id = 0, _amount = 0) constructor
{
	name      =    _name;
	item_id   = _item_id;
	amount    =  _amount;
	
	static isEmpty = function()
	{
		return (name == "" && item_id == 0 && amount = 0);
	}
	
	static equals = function(_name, _item_id)
	{
		return (name == _name && item_id == _item_id);	
	}
	
	static toString = function()
	{
		return string("Item is: { Name:" + name + ", Item ID: " + string(item_id)) + "}";	
	}
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

enum ITEM_ID
{
	none,
	
	grass,
	stone,
	
	coal,
	copper,
	iron,
	silver,
	gold,
	ruby,
	sapphire,
	emerald,
	diamond,
	last_ore,
	
	enemy_parts,
	pot_of_greed,
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
											 
			case UPGRADE.jetpack_fuel:		{ obj_player.stat_jetpack_fuel = 50 + _up*30; } break;
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

global.ore_distribution = array_create(ITEM_ID.last_ore);
global.ore_distribution[ITEM_ID.coal] =       { high: -1000, low: 500    };
global.ore_distribution[ITEM_ID.copper] =     { high: -2000, low: 250  };
global.ore_distribution[ITEM_ID.iron] =		  { high: -2500, low: 0 };
global.ore_distribution[ITEM_ID.silver] =     { high: -5000, low: -1250 };
global.ore_distribution[ITEM_ID.gold] =       { high: -6500, low: -2000 };
global.ore_distribution[ITEM_ID.ruby] =		  { high: -7500, low: -2500 };
global.ore_distribution[ITEM_ID.sapphire] =   { high: -8500, low: -3500 };
global.ore_distribution[ITEM_ID.emerald] =    { high: -9000, low: -4000 };
global.ore_distribution[ITEM_ID.diamond] =    { high: -10000, low: -5000 };


function choose_ore(y)
{
	var _g = global.ore_distribution;
	
	show_debug_message("y is: ");
	show_debug_message(y);
	
	for (var _i = ITEM_ID.last_ore-1; _i > ITEM_ID.stone; _i--)
	{
		if (y < _g[_i].low && y <= irandom_range(_g[_i].high, _g[_i].low))
			return _i;	
	}
	
	return ITEM_ID.stone;
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