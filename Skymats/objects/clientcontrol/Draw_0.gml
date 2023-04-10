/// @description Insert description here
// You can write your code in this editor
if (instance_exists(obj_player))
{
	shader_set(shd_mix_colors);
	shader_set_uniform_f(shader_get_uniform(shd_mix_colors, "_mix"), (obj_player.y-7000)/1000);
	shader_set_uniform_f_array(shader_get_uniform(shd_mix_colors, "color_1"), [1.0, 1.0, 1.0, 1.0]);
	shader_set_uniform_f_array(shader_get_uniform(shd_mix_colors, "color_2"), [0.0, 0.0, 1.0, 1.0]);
	draw_rectangle(x, y, x+1366, y+768, false);
	shader_reset();
}