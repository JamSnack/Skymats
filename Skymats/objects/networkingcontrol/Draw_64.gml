/// @description Insert description here
// You can write your code in this editor

var _w = display_get_gui_width();
var _h = display_get_gui_height();

draw_text(600, 10, 
	"Socket_list size: " + string(ds_list_size(global.socket_list)) + "\n" +
	"Client ID: " + string(global.client_id)


);

if (global.game_state == "LOAD")
{
	draw_set_alpha(0.5);
	draw_rectangle_color(0, 0, _w, _h, c_black, c_black, c_black, c_black, false);
	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_text(_w/2, _h/2, "Loading World...");
	draw_set_halign(fa_left);
}