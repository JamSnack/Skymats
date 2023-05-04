/// @description Insert description here
// You can write your code in this editor
if (global.tutorial_complete)
	instance_destroy();

if (instance_exists(obj_player) && collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true) != noone && !global.tutorial_complete)
	global.tutorial_complete = true;