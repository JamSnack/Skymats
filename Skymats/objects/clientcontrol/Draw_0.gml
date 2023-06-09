/// @description Insert description here
// You can write your code in this editor
if (instance_exists(obj_platform))
{
	//Draw background
	var _x = camera_get_view_x(view_camera[0])-1366/2;
	var _y =  camera_get_view_y(view_camera[0])-768/2;
	var mix =  (global.platform_height-floor(global.platform_height/height_range)*height_range)/height_range;
	
	shader_set(shd_mix_colors);
	shader_set_uniform_f(shader_get_uniform(shd_mix_colors, "_mix"), mix);
	shader_set_uniform_f_array(shader_get_uniform(shd_mix_colors, "color_1"), background_colors[0]);
	shader_set_uniform_f_array(shader_get_uniform(shd_mix_colors, "color_2"), background_colors[1]);
	draw_rectangle(_x, _y, _x+1366, _y+768, false);
	shader_reset();
}