/// @description Insert description here
// You can write your code in this editor

if (stage == 0 && image_alpha < 1)
	image_alpha += 0.01;
else stage = 1;

if (stage == 1)
{
	life_time -= 0.01;
	image_alpha = life_time;
	
	if (life_time <= 0)
		instance_destroy();
}