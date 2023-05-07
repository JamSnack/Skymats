/// @description Insert description here
// You can write your code in this editor

if (time > 0)
{
	var _xscale = 8;
	var _yscale = 3;
	var _width = (_xscale)*54*time;
	var _height =  (_yscale)*time*54;
	var _x = display_get_gui_width()/2 - _width/2;
	var _y = display_get_gui_height()/2 - 260 - _height/2;

	draw_sprite_ext(spr_ui_black_background, 0, _x, _y, _xscale*time, _yscale*time, 0, c_white, time);

	draw_set_halign(fa_center);
	draw_text_scribble_ext(_x + _width/2, _y + _height/2 - 32, text, _width - 8, string_length(text)*(time-0.5));
	draw_set_halign(fa_left);
}