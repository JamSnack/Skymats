/// @description Insert description here
// You can write your code in this editor

draw_self();

if (global.stored_resource_to_burn != 0)
	draw_sprite_ext(spr_items, global.stored_resource_to_burn, x + 27, y + 27, 0.5, 0.5, 0, c_white, 1.0);