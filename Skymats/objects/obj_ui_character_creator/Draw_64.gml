/// @description Draw Window and its contents
draw_set_alpha(window_alpha);

var _w = display_get_gui_width();
var _h = display_get_gui_height();

draw_set_halign(fa_center);

//Text
draw_text_scribble(_w/2, 40, "[scale, 3][font][pulse]Create Character");

//Character
draw_sprite_ext(spr_player_run, current_time/100, _w/2, 220, 8, 8, 0, c_white, 1.0);

//Character Colors

//reset
draw_set_alpha(1);
draw_set_halign(fa_left);