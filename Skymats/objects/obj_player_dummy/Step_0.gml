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
var on_ground = (position_meeting(bbox_left, bbox_bottom+1, OBSTA) || position_meeting(bbox_right, bbox_bottom+1, OBSTA));

if (on_ground && hspd != 0)
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
if (vspd > 2)
	image_angle = lerp(image_angle, point_direction(x, y, x+hspd, y+vspd)-90, 0.1);
else
	image_angle = lerp(image_angle, 0, 0.2);