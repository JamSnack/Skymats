/// @description Insert description here
// You can write your code in this editor
sync_position();
update_shadow(shadow);

vspd = lerp(vspd, y-yprevious, 0.33);
hspd = lerp(hspd, x-xprevious, 0.33);

if (hspd != 0)
	image_xscale = sign(hspd);

//Sprite control
/*.if (grapple_is_launching)
{
	sprite_index = spr_player_hook;
	image_index = lerp(image_index, 5, 0.1);
}
else if (grappling)
{
	sprite_index = spr_player_hook;
	image_index = 5;
}
*/

//grappling
if (grapple_amt <= 0)
{
	target_grapple_point_x = x;
	target_grapple_point_y = y;
} else grapple_amt--;

//Sprites
var on_ground = (position_meeting(bbox_left, bbox_bottom+1, OBSTA) || position_meeting(bbox_right, bbox_bottom+1, OBSTA));
if (grapple_amt > 0 && target_grapple_point_x != x && target_grapple_point_y != y)
{
	sprite_index = spr_player_hook;
	image_index = lerp(image_index, 5, 0.1);
	
	grapple_point_x = lerp(grapple_point_x, target_grapple_point_x, 0.3);
	grapple_point_y = lerp(grapple_point_y, target_grapple_point_y, 0.3);
}
else if (on_ground && hspd != 0)
{
	sprite_index = spr_player_run;
	image_speed = hspd/2;
}
else if (!on_ground)
{
	if (vspd < 0)
	{
		sprite_index = spr_player_jump;
		image_index = lerp(image_index, 5, 0.1);
	}
	else
	{
		sprite_index = spr_player_fall;
		image_speed = vspd/2;
	}
}
else sprite_index = spr_player_idle;

//Angle control
image_angle = lerp(image_angle, target_angle, 0.2);

if (vspd > 2)
	image_angle = lerp(image_angle, point_direction(x, y, x+hspd, y+vspd)-90, 0.1);
else
	image_angle = lerp(image_angle, 0, 0.2);

//Jetpacking
if (jetpacking_amt > 0)
{
	create_smoke(x - (3*image_xscale), y + 5, point_direction(x, y, x+hspd, y+vspd), 2);
	jetpacking_amt--;
}