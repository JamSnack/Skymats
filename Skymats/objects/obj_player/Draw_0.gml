/// @description Insert description here
draw_self();

//Sword
//draw_sprite_ext(spr_sword, 0, x, y, 1, 1, sword_angle, c_white, 1);

//Grapple
if (grapple_launch_length > 0)
{
	draw_line(x, y, grapple_point_x, grapple_point_y);
	
	draw_sprite_ext(spr_grapple, 0, grapple_point_x, grapple_point_y, 1, 1, grapple_direction, c_white, 1);
}

