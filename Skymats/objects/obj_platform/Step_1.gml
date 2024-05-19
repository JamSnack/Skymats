/// @description Insert description here
// You can write your code in this editor

//move everything
if (SCROLL_CONDITIONS)
{
	with (obj_player)
	{
		if !(on_ground != noone && on_ground.object_index == obj_platform) && !place_meeting(x, y+1, obj_platform)
			x += SCROLL_SPEED;
			
		if (collision_rectangle(bbox_right-2, bbox_top, bbox_right, bbox_bottom, TILE, false, true) != noone)
			x -= SCROLL_SPEED;
		else if (collision_rectangle(bbox_left-1, bbox_top, bbox_left+2, bbox_bottom, TILE, false, true) != noone)
			x += SCROLL_SPEED;
	}
	
	with (TILE)
	{
		x += SCROLL_SPEED;
		layer_sprite_x(shadow, x+2); //Update shadows
	}
}









