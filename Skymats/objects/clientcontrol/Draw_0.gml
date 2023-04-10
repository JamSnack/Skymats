/// @description Insert description here
// You can write your code in this editor
if (instance_exists(camera))
{
	var _x = camera.x-1366/2;//camera_get_view_border_x(view_camera[0]);
	var _y = camera.y-768/2;//camera_get_view_border_y(view_camera[0]);
	var colors = get_background_colors(camera.y);
	//show_debug_message(colors[1]);
	shader_set(shd_mix_colors);
	shader_set_uniform_f(shader_get_uniform(shd_mix_colors, "_mix"), (camera.y-floor(camera.y/1000)*1000)/1000);
	shader_set_uniform_f_array(shader_get_uniform(shd_mix_colors, "color_1"), colors[0]);
	shader_set_uniform_f_array(shader_get_uniform(shd_mix_colors, "color_2"), colors[1]);
	draw_rectangle(_x, _y, _x+1366, _y+768, false);
	shader_reset();
}