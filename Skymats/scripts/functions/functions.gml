// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

#macro GRAVITY 0.1
#macro WORLD_BOUND_LEFT 0
#macro WORLD_BOUND_RIGHT room_width
#macro WORLD_BOUND_TOP 0
#macro WORLD_BOUND_BOTTOM room_height

#macro CHUNK_WIDTH 1586
#macro CHUNK_HEIGHT 768

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

function hurt_enemy(inst, k_direction, k_amt, damage)
{
	if (instance_exists(inst))
	{
		with (inst)
		{
			motion_add_custom(k_direction, k_amt);
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
	
		hspd = 0;
	}

	x += hspd;

	//Vertcial Collision
	if (collision_rectangle(bbox_left, bbox_top + vspd, bbox_right, bbox_bottom + vspd, OBSTA, false, true) != noone)
	{
		var _v = (vspd > 0) ? min(sign(vspd), vspd) : max(sign(vspd), vspd);
	
		while (collision_rectangle(bbox_left, bbox_top + _v, bbox_right, bbox_bottom + _v, OBSTA, false, true) == noone)
		{
			y += _v;
		}
	
		vspd = 0;
	}

	y += vspd;	
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
		instance_create_layer(x, y, "Instances", obj_client_request_chunk);
		instance_create_layer(x, y-CHUNK_HEIGHT, "Instances", obj_client_request_chunk);
		instance_create_layer(x, y+CHUNK_HEIGHT, "Instances", obj_client_request_chunk);
		instance_create_layer(x+CHUNK_WIDTH, y, "Instances", obj_client_request_chunk);
		//instance_create_layer(x, y, "Instances", obj_client_request_chunk);
		
		
		//for (var _i = 0; _i < 3; _i++)
			//instance_create_layer(x-CHUNK_WIDTH + CHUNK_WIDTH*_i, y, "Instances", obj_client_request_chunk);
		
		//for (var _i = 0; _i < 3; _i++)
			//instance_create_layer(x-CHUNK_WIDTH + CHUNK_WIDTH*_i, y-CHUNK_HEIGHT, "Instances", obj_client_request_chunk);
		
		//for (var _i = 0; _i < 3; _i++)
			//instance_create_layer(x-CHUNK_WIDTH + CHUNK_WIDTH*_i, y+CHUNK_HEIGHT, "Instances", obj_client_request_chunk);	
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
		case ITEM_ID.grass:  { return obj_grass; } break;
		case ITEM_ID.stone:  { return obj_stone; } break;
		case ITEM_ID.copper: { return obj_copper;} break;
		default:			 { return -1;        } break;
	}
}

function get_item_value(item_id)
{
	switch item_id
	{
		case ITEM_ID.grass:  { return  1; } break;
		case ITEM_ID.stone:  { return  2; } break;
		case ITEM_ID.copper: { return  5; } break;
		default:			 { return -1; } break;
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
	copper,
	last
}


enum UPGRADE
{
	none,
	grapple_range,
	grapple_travel,
	grapple_strength,
	mine_strength,
	mine_speed,
	jetpack_fuel,
	jetpack_force,
	jetpack_cooldown,
	jetpack_regen_rate,
	weapon_speed,
	weapon_damage,
	weapon_range,
	weapon_knockback,
	last
}

function get_upgrade_cost(upgrade_id)
{
	if (instance_exists(obj_player))
	{
		var _up = obj_player.upgrades_purchased[upgrade_id];
		
		switch upgrade_id
		{
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
			
			default: { return 1337; } break;
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
			case UPGRADE.grapple_range:		{ obj_player.stat_grapple_range = _up } break;
			case UPGRADE.grapple_travel:	{ obj_player.stat_grapple_speed = _up } break;
			case UPGRADE.grapple_strength:  { obj_player.stat_grapple_force = _up } break;
											 
			case UPGRADE.mine_strength:	    { obj_player.stat_mine_level    = _up; } break;
			case UPGRADE.mine_speed:		{ obj_player.stat_mine_cooldown = _up; } break;
											 
			case UPGRADE.jetpack_fuel:		{ obj_player.stat_jetpack_fuel        = _up; } break;
			case UPGRADE.jetpack_force:		{ obj_player.stat_jetpack_strength    = _up; } break;
			case UPGRADE.jetpack_cooldown:	{ obj_player.stat_jetpack_cooldown    = _up; } break;
			case UPGRADE.jetpack_regen_rate:{ obj_player.stat_jetpack_regen_rate  = _up; } break;
											  
			case UPGRADE.weapon_speed:		{ obj_player.stat_weapon_cooldown   = _up; } break;
			case UPGRADE.weapon_damage:		{ obj_player.stat_weapon_damage     = _up; } break;
			case UPGRADE.weapon_range:		{ obj_player.stat_weapon_range      = _up; } break;
			case UPGRADE.weapon_knockback:  { obj_player.stat_weapon_knockback  = _up; } break;
		}
	}
}