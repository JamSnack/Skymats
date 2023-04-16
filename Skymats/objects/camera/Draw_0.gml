/// @description Insert description here
// You can write your code in this editor

draw_sprite_stretched(spr_boundary, 0, 0, WORLD_BOUND_TOP, room_width, 64);
draw_sprite_stretched(spr_boundary, 0, 0, WORLD_BOUND_BOTTOM, room_width, 64);

draw_sprite_stretched(spr_boundary, 0, -64, global.platform_height, 64, room_height);
draw_sprite_stretched(spr_boundary, 0, WORLD_BOUND_RIGHT, global.platform_height, 64, room_height);