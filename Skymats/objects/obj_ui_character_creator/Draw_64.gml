/// @description Draw Window and its contents
draw_set_alpha(window_alpha);

var _w = display_get_gui_width();
var _h = display_get_gui_height();

draw_set_halign(fa_center);

//Text
draw_rectangle_color(_w/2 - 310, 30, _w/2 + 302, 140, c_black, c_black, c_black, c_black, false);
draw_text_scribble(_w/2, 40, "[scale, 3][font][pulse]Create Character");

//Character
draw_sprite_ext(spr_player_run, current_time/100, _w/2, 220, 8, 8, 0, c_white, 1.0);

//Charcter name
var h_size = 80;
var w_size = 600;
draw_sprite_stretched(spr_ui_background_2, 0, _w/2 - w_size/2, _h/2 - h_size/2, w_size, h_size)
draw_text_scribble(_w/2, _h/2 - 80, "[default_outlined][scale, 2]Enter Name");
draw_text_scribble(_w/2, _h/2 - 20, "[scale, 1.5][font]" + string(username));

if (typing_name)
	draw_text_scribble(_w/2, _h/2 + 80, "[default_outlined]Press Enter to confirm.");

//Character Colors

//Complete!
var h_size = 90;
var w_size = 400;
draw_sprite_stretched(spr_ui_background_2, 0, _w/2 - w_size/2, _h/2 - h_size/2 + 320, w_size, h_size);
draw_text_scribble(_w/2, _h/2 + 300, "[font][scale, 2]Play");

//reset
draw_set_alpha(1);
draw_set_halign(fa_left);