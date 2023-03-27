/// @description Insert description here
draw_self();

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