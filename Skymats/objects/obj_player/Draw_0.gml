/// @description Insert description here

//Sword
//draw_sprite_ext(spr_sword, 0, x, y, 1, 1, sword_angle, c_white, 1);

//Grapple
if (grapple_launch_length > 0)
{
	draw_line(x, y, grapple_point_x, grapple_point_y);
	
	draw_sprite_ext(spr_grapple, 0, grapple_point_x, grapple_point_y, 1, 1, grapple_direction, c_white, 1);
}

//Jetpack
if (jetpack_fuel < stat_jetpack_fuel)
{
	draw_healthbar_custom(x, y+20, jetpack_fuel, stat_jetpack_fuel, jetpack_fuel_draw/stat_jetpack_fuel, c_yellow, c_white);
	//draw_rectangle_color(x-20, y+20, x+20, y+20+4, c_black, c_black, c_black, c_black, false);
	//draw_rectangle_color(x-20, y+20, x-20 + 40*(jetpack_fuel/stat_jetpack_fuel), y+20+4, c_yellow, c_yellow, c_yellow, c_yellow, false);
}

//Auto-Attack Cooldown
if (weapon_cooldown > 0)
{
	draw_healthbar_custom(x, y+30, weapon_cooldown, stat_weapon_cooldown, 0, c_red, c_teal);
	//draw_rectangle_color(x-20, y+30, x+20, y+30+4, c_black, c_black, c_black, c_black, false);
	//draw_rectangle_color(x-20, y+30, x-20 + 40*(weapon_cooldown/stat_weapon_cooldown), y+30+4, c_red, c_red, c_red, c_red, false);
}

//Tile selection and cursor text
if (instance_exists(_tile) && _tile.tile_level <= stat_mine_level)
{
	draw_sprite_ext(spr_tile_selection, 0, _tile.x, _tile.y, 1, 1, 0, c_white, 0.1 + 0.3*abs(sin(current_time/900)) );
	
	//tile cursor text
	draw_text_scribble(x + lengthdir_x(mine_laser_distance, mine_laser_direction), y + lengthdir_y(mine_laser_distance, mine_laser_direction) + 12, "[default_outlined][scale, 0.5][fa_center][c_green]$" + string(get_item_value(_tile.item_id)) + "[/c] | " + get_item_name(_tile.item_id));
}


//Tile placement
/*
var _x = get_coordinate_on_world_grid(mouse_x+8);
var _y = get_coordinate_on_world_grid(mouse_y+8);

if (global.inventory.selected_slot != -1 && distance_to_point(_x, _y) < 16*5 && get_tile_object_from_item(global.inventory.contents[global.inventory.selected_slot].item_id) != -1 && collision_point(_x, _y, OBSTA, false, true) == noone)
{
	draw_sprite(spr_place_item, current_time/100, _x, _y);
}
else if (global.inventory.selected_slot != -1)
	draw_sprite(spr_place_no_item, current_time/100, _x, _y);
*/

//Mining-Laser
if (mouse_check_button(mb_left))
{
	if (!surface_exists(mine_surface))
		mine_surface = surface_create(64 + 8, 8);
	
	surface_set_target(mine_surface);
	draw_clear_alpha(c_white, 0);
	draw_sprite_stretched_ext(spr_mining_laser, current_time/40, 0, 0, mine_laser_distance, 6, c_white, 0.9 + 0.1*sin(current_time/20));
	draw_sprite_ext(spr_mine_spark, 0, mine_laser_distance, 0, 0.6+random(0.4), 0.6+irandom(0.4), 0, c_white, 1);
	surface_reset_target();
	
	draw_surface_ext(mine_surface, x, y, 1, 1, mine_laser_direction, c_white, 1);
}
else
{
	//Mining cursor
	draw_sprite(spr_ui_minig_cursor, 0, x + lengthdir_x(mine_laser_distance, mine_laser_direction), y + lengthdir_y(mine_laser_distance, mine_laser_direction));
}

//Draw player
if (hurt_effect != 0)
{
	gpu_set_fog(true, c_red, 0, hurt_effect);
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale + hurt_effect/2, image_yscale + hurt_effect/2, draw_angle, c_white, image_alpha);
	gpu_set_fog(false, c_white, 0, 0);
}
else draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, draw_angle, c_white, image_alpha);

//Draw direction
/*
draw_arrow(x, y, x+hspd, y+vspd, abs(hspd)+abs(vspd));
draw_set_color(c_red);
var _diff = angle_difference(point_direction(x, y, grapple_point_x, grapple_point_y), point_direction(x, y, x+hspd, y+vspd) );
draw_arrow(x, y, x+lengthdir_x(20, _diff), y+lengthdir_y(20, _diff), 2);
draw_set_color(c_white);