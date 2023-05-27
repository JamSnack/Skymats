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
	draw_rectangle_color(x-20, y+20, x+20, y+20+4, c_black, c_black, c_black, c_black, false);
	draw_rectangle_color(x-20, y+20, x-20 + 40*(jetpack_fuel/stat_jetpack_fuel), y+20+4, c_yellow, c_yellow, c_yellow, c_yellow, false);
}

//Auto-Attack Cooldown
if (weapon_cooldown > 0)
{
	draw_rectangle_color(x-20, y+30, x+20, y+30+4, c_black, c_black, c_black, c_black, false);
	draw_rectangle_color(x-20, y+30, x-20 + 40*(weapon_cooldown/stat_weapon_cooldown), y+30+4, c_red, c_red, c_red, c_red, false);
}

//Tile selection
if (instance_exists(_tile) && _tile.tile_level <= stat_mine_level)
	draw_sprite_ext(spr_tile_selection, 0, _tile.x, _tile.y, 1, 1, 0, c_white, 0.1 + 0.3*abs(sin(current_time/900)) );

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

//Draw player
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, draw_angle, c_white, image_alpha);