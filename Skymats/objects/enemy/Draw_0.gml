/// @description Insert description here
// You can write your code in this editor
event_inherited();
if (hit_effect != 0)
{
	gpu_set_fog(true, c_white, 0, 1);
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale + hit_effect, image_yscale + hit_effect, image_angle, c_white, image_alpha);
	gpu_set_fog(false, c_white, 0, 0);
}
else draw_self();

if (hp < max_hp)
{
	draw_rectangle_color(x-10, y + 10, x+10, y + 10 + 4, c_black, c_black, c_black, c_black, false);	
	draw_rectangle_color(x-10, y + 10, x-10 + 20*(hp/max_hp), y + 10 + 4, c_green, c_green, c_green, c_green, false);
}