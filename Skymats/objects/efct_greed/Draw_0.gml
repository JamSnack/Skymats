/// @description Insert description here
// You can write your code in this editor
draw_sprite_ext(spr_pot_of_greed, animation_count*119, x, y, 1, 1, 0, c_white, 1.0);

if (animation_count < 1)
	draw_set_alpha(animation_count + 0.05);
else 
	draw_set_alpha(lifetime);

draw_set_color(c_red);
draw_set_halign(fa_center);
draw_text_scribble(x, y + 200, "[scale, 3]You're in danger");
draw_set_halign(fa_left);
draw_set_alpha(1);
draw_set_color(c_white);
