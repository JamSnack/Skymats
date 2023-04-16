/// @description Insert description here
// You can write your code in this editor
x += SCROLL_SPEED*10;

if (x > room_width || y > WORLD_BOUND_BOTTOM+300)
	instance_destroy();

alarm[0] = 10;