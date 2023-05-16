/// @description Insert description here
// You can write your code in this editor

function draw_widget(x, y)
{
	draw_set_color(c_gray);
	draw_rectangle(x + 16, y + 16, x + 16 + 64, y + 16 + 64, false);
	draw_set_color(c_white);
	
	draw_sprite_ext(spr_items, ITEM_ID.coal, x + 16, y + 16, 2, 2, 0, c_white, 1);
}