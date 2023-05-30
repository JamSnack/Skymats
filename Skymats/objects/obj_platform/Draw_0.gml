/// @description Insert description here
// You can write your code in this editor
draw_rectangle_color( bbox_left + 4, bbox_top + 2, bbox_left + (bbox_right-bbox_left-2)*(fuel/max_fuel), bbox_bottom - 8, c_white, c_white, c_white, c_white, false);
draw_rectangle_color( bbox_left + 4, bbox_top + 2, bbox_left + (bbox_right-bbox_left-2)*(draw_fuel/max_fuel), bbox_bottom - 8, c_teal, c_yellow, c_yellow, c_teal, false);
draw_self();
//draw_text(x, y, "Height: " + string(global.platform_height) + "\n" +
//"Fuel: " + string((fuel/max_fuel)*100) + "%\n"

//draw_rectangle_color( bbox_left + 2, bbox_top + 2, bbox_right - 2, bbox_top + 6, c_black, c_black, c_black, c_black, false);


if (obstruction)
	draw_text_scribble(x, y-96, "[fa_center][spr_ui_warning]\n[blink]OBSTRUCTED");