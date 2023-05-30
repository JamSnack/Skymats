/// @description
lifetime -= 0.01;

if (lifetime <= 0)
	instance_destroy();

image_angle += hspeed*2;

//Collision
if (!place_empty(x+hspeed, y, OBSTA))
	hspeed = -hspeed*0.5;
	
if (!place_empty(x, y+vspeed, OBSTA))
{
	vspeed = -vspeed*0.5;
	gravity = 0;
}
else
	gravity = 0.1;