/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_player) && collision_rectangle(bbox_left, bbox_top-8, bbox_right, bbox_bottom, obj_player, false, true) != noone)
{
	obj_player.x = 400;
	obj_player.y = 602;
}