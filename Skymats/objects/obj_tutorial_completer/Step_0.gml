/// @description Insert description here
// You can write your code in this editor
if (global.platform_height < -1000 && instance_exists(obj_player) && obj_player.y < bbox_bottom)
	instance_destroy();