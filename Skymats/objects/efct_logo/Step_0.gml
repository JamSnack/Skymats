/// @description Insert description here
// You can write your code in this editor

if (time < 1.0 && lifetime > 0)
	time = lerp(time, 1, 0.02);
else if (lifetime <= 0)
{
	time -= 0.01;
	
	if (time <= -120)
		instance_destroy();
}
else lifetime--;