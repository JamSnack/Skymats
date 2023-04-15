/// @description Insert description here
draw_self();

//Health
if (hp < max_hp)
{
	draw_rectangle_color(x-20, y+20, x+20, y+20+4, c_black, c_black, c_black, c_black, false);
	draw_rectangle_color(x-20, y+20, x-20 + 40*(hp/max_hp), y+20+4, c_lime, c_lime, c_lime, c_lime, false);
}