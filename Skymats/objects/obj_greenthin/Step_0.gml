//Simple player-tracking Ai
var on_ground = position_meeting(x, bbox_bottom+1, OBSTA);
var over_ground = collision_line(x + hspd*16, bbox_bottom, x + hspd*16, bbox_bottom+64, OBSTA, false, true);
if (SCROLL_CONDITIONS && !position_meeting(bbox_right + SCROLL_SPEED, y, OBSTA))
	x += SCROLL_SPEED;

var _p = instance_nearest(x, y, PLAYER);
	
if (_p != noone)
{
	motion_add_custom(point_direction(x, 0, _p.x, 0), 0.1);
	
	//Jump if target player is above the creature
	if (on_ground && vspd == 0 && obj_player.y < y-8 && distance_to_object(_p) < 16*12)
		motion_add_custom(90, 2);
}

//Keep the enemy on the ground
if (over_ground == noone)
	motion_add_custom(point_direction(x, y, x-ground_direction, y), 0.5);
else 
	ground_direction = sign(hspd);

vspd += GRAVITY*weight;
calculate_collisions();
keep_in_bounds();
target_x += hspd;
target_y += vspd;
	
//Speed clamp
clamp_speed(-max_hspeed, max_hspeed, -max_vspeed, max_vspeed);

event_inherited();