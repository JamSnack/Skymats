/// @description Insert description here
// You can write your code in this editor

if (collision_rectangle(bbox_left, bbox_top - 16*4, bbox_right, bbox_top, OBSTA, false, true) == noone)
{
	obstruction = false;
	if (fuel > 2)
	{
		global.platform_height -= 1;
		fuel -= 2;
		target_y -= 1;
	}

	if (y != target_y)
	{
		y = lerp(y, target_y, 0.1);
	
		obj_market.y = bbox_top-74;
	
		if (collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true) != noone)
		{
			obj_player.y = bbox_top-9;
			obj_player.vspd = 0;
		}
	}
}
else obstruction = true;


//move everything
with (TILE)
	x += SCROLL_SPEED;