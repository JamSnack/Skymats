/// @description Insert description here
// You can write your code in this editor
lifetime -= 0.015;
if (lifetime <= 0)
	instance_destroy();
	
image_alpha = lifetime;
image_angle += speed*0.1;

x += SCROLL_SPEED;