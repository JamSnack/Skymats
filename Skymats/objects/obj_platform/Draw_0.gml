/// @description Insert description here
// You can write your code in this editor
draw_self();
draw_text(x, y, "Height: " + string(global.platform_height));

if (obstruction)
	draw_text(x, y+20, "OBSTRUCTED!!!");