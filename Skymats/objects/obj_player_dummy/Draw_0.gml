/// @description Insert description here
draw_self();

//Health
if (hp < max_hp)
{
	draw_rectangle_color(x-20, y+20, x+20, y+20+4, c_black, c_black, c_black, c_black, false);
	draw_rectangle_color(x-20, y+20, x-20 + 40*(hp/max_hp), y+20+4, c_lime, c_lime, c_lime, c_lime, false);
}

//Grapple
if (grapple_amt > 0 && target_grapple_point_x != x && target_grapple_point_y != y)
{
	draw_line(x, y, grapple_point_x, grapple_point_y);
	draw_sprite_ext(spr_grapple, 0, grapple_point_x, grapple_point_y, 1, 1, grapple_direction, c_white, 1);
}