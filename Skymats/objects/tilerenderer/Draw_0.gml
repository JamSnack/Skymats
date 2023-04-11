/// @description Insert description here
// You can write your code in this editor

with (TILE)
{
	draw_sprite(sprite_index, image_index, x, y);

	if (draw_damage)
		draw_sprite(spr_break_tile, damage, x, y);	
}