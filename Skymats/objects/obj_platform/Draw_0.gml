/// @description Insert description here
// You can write your code in this editor
draw_self();
//draw_text(x, y, "Height: " + string(global.platform_height) + "\n" +
//"Fuel: " + string((fuel/max_fuel)*100) + "%\n"

draw_rectangle_color( bbox_left + 2, bbox_top + 2, bbox_right - 2, bbox_top + 6, c_black, c_black, c_black, c_black, false);
draw_rectangle_color( bbox_left + 2, bbox_top + 2, bbox_left + (bbox_right-bbox_left)*(fuel/max_fuel), bbox_top + 6, c_orange, c_orange, c_green, c_green, false);

if (obstruction)
	draw_text(x, y-64, "OBSTRUCTED!!!");