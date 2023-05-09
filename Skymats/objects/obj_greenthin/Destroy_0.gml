/// @description Insert description here
// You can write your code in this editor


// Inherit the parent event
event_inherited();

if (global.is_host)
	instance_create_layer(x, y, "Instances", obj_item, {item_id: ITEM_ID.enemy_parts});
	
