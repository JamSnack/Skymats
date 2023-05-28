/// @description Insert description here
// You can write your code in this editor
vspd += GRAVITY*weight;
calculate_collisions();
target_x += hspd;
target_y += vspd;

image_angle = point_direction(xprevious, yprevious, x, y); //We actually want to change the hitbox in this case
draw_angle = image_angle;

//Speed clamp
clamp_speed(-max_hspeed, max_hspeed, -max_vspeed, max_vspeed);

//Destroy
if (position_meeting(x, y, OBSTA) || (hspd == 0 && vspd == 0))
	instance_destroy();

// Inherit the parent event
event_inherited(); 