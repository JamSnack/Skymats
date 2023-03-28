/// @description Insert description here
// You can write your code in this editor

draw_self();

if (hp < max_hp)
{
	draw_rectangle_color(x-10, y + 10, x+10, y + 10 + 4, c_black, c_black, c_black, c_black, false);	
	draw_rectangle_color(x-10, y + 10, x-10 + 20*(hp/max_hp), y + 10 + 4, c_green, c_green, c_green, c_green, false);
}