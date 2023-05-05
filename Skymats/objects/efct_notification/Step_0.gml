/// @description Insert description here
// You can write your code in this editor

if (time < 1.0 && lifetime > 0)
	time += 0.15;
else if (lifetime <= 0)
{
	time -= 0.1;
	
	if (time <= 0)
		instance_destroy();
}
else lifetime--;